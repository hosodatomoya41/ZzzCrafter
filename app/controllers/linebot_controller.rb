# frozen_string_literal: true

class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return head :bad_request unless client.validate_signature(body, signature)

    events = client.parse_events_from(body)
    events.each do |event|
      case event
        when Line::Bot::Event::Postback
          data = event['postback']['data']
          handle_postback(event, data)
        when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          handle_message(event)
        end
      end
    end
  end

  private
  
  def handle_message(event)
    line_user_id = event['source']['userId']
    user = User.find_by(line_user_id: line_user_id)
    received_text = event.message['text']

    if %w[調子は良い 調子は普通 調子は悪い].include?(received_text)
      record_morning_condition(user, received_text, event)
    elsif %w[睡眠の記録を見る ルーティーン一覧を見る おすすめのルーティーンを教えて].include?(received_text)
      Richmenu.postback(user, event, received_text)
    elsif received_text =~ /^(\d{4}年)?(1[0-2]|0?[1-9])月$/
      handle_month(user, event, received_text)
    else
      handle_register_routine(user, event, received_text)
    end
  end
  
  def handle_postback(event, data)
    user_id = event['source']['userId']
    user = User.find_by(line_user_id: user_id)
    params = Rack::Utils.parse_nested_query(data)
    case params['action']
    when 'wakeup', 'sleep'
      handle_sleeptime(user, event, params)
    when 'show_routines'
      handle_show_routines(user, event, params)
    when 'add_routine'
      handle_register_routine(user, event, params)
    end
  end

  def handle_month(user, event, received_text)
    current_year = Date.today.year
  
    if received_text.include?("年")
      # ユーザーが年も指定している場合、その年と月を取得
      year, month = received_text.split('年').first.to_i, received_text.split('年').last.split('月').first.to_i
    else
      # ユーザーが月だけを指定している場合、現在の年を使用
      year = current_year
      month = received_text.split('月').first.to_i
    end
  
    # 月のデータを取得するための範囲を決定
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    
    sleep_records = SleepRecord.fetch_records(user.id, start_date, end_date)
    grouped_sleep_records = sleep_records.group_by(&:record_date)
    
    # 取得したデータをもとにFlex Messageを生成して送信
    message_text = Richmenu.handle_sleeprecord(event, user, grouped_sleep_records)
    client.reply_message(event['replyToken'], message_text)
  end

  def handle_sleeptime(user, event, params)
    time = event['postback']['params']['time']
    if params['action'] == 'wakeup'
    user.update(notification_time: Time.zone.parse(time))
    message_text = "起床時間を#{time}に設定しました！"
    else
    user.update(bedtime: Time.zone.parse(time))
    message_text = "就寝時間を#{time}に設定しました！"
    end
    LineMessagingService.send_reply(event['replyToken'], message_text)
  end
  
  def handle_show_routines(user, event, params)
    times = params['times']
    routine_ids = times.map { |time| Routine.recommend_times[time] }
    routines = Routine.where(recommend_time: routine_ids)
    message_text = Richmenu.routines_index(routines, event)
    client.reply_message(event['replyToken'], message_text)
  end
  
  def handle_register_routine(user, event, received_text)
    if received_text.is_a?(Hash)
      routine_id = received_text['routine_id']
      routine = Routine.find_by(id: routine_id)
      received_text = routine.line_text
    end
    result = user.register_routine(received_text)

    case result[:status]
    when :existing_routine
      message_text = "既に【#{result[:name]}】は本日登録されたようです！\n継続は力なり、がんばってくださいね！"
    when :no_bedtime
      message_text = "【#{result[:name]}】を登録しました。\n就寝時間の設定をして頂くと、ルーティーンの実践に適正な時間が分かります！\nぜひ、メニューの【睡眠の記録】から就寝時間の設定をしてみてください！"
    when :success
      message_text = "【#{result[:name]}】を登録しました。\n就寝時間から逆算すると、 #{result[:recommend_time]}頃に実践するのがオススメです！\n睡眠の質を高められるように頑張ってくださいね！"
    end
    LineMessagingService.send_reply(event['replyToken'], message_text)
  end

  def record_morning_condition(user, received_text, event)
    message_text = SleepRecord.record_condition(user.id, received_text)
    puts "調子を記録しました #{message_text}"
    LineMessagingService.send_reply(event['replyToken'], message_text)
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
