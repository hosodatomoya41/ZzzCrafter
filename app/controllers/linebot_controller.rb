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
  
  def handle_postback(event, data)
    user_id = event['source']['userId']
    user = User.find_by(line_user_id: user_id)
    params = Rack::Utils.parse_nested_query(data)
    postback_params = event['postback']['params']
    time = Time.zone.parse(postback_params['time']).strftime('%H:%M')

    if params['action'] == 'wakeup'
      user.update(notification_time: Time.zone.parse(postback_params['time']))
      message_text = "起床時間を#{time}に設定しました！"
    elsif params['action'] == 'sleep'
      user.update(bedtime: Time.zone.parse(postback_params['time']))
      message_text = "就寝時間を#{time}に設定しました！"
    end

    LineMessagingService.send_reply(event['replyToken'], message_text)
  end

  def handle_message(event)
    line_user_id = event['source']['userId']
    user = User.find_by(line_user_id: line_user_id)
    received_text = event.message['text']

    if %w[調子は良い 調子は普通 調子は悪い].include?(received_text)
      record_morning_condition(user, received_text, event)
    elsif %w[睡眠の記録を見る ルーティーン一覧を見る おすすめのルーティーンを教えて アプリの使い方].include?(received_text)
      Richmenu.postback(user, event, received_text)
    elsif received_text =~ /^(\d{4}年)?(1[0-2]|0?[1-9])月$/
      handle_month(user, event, received_text)
    else
      register_routine(user, received_text, event)
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
    message = Richmenu.handle_sleeprecord(event, user, grouped_sleep_records)
    client.reply_message(event['replyToken'], message) 
  end
  
  

  def register_routine(user, received_text, event)
    result = user.register_routine(received_text)

    case result
    when :existing_routine
      message_text = "既にそのルーティーンは本日登録されたようです！\n継続は力なり、がんばってくださいね！"
    when :no_bedtime
      message_text = "登録が完了しました！\nまだ就寝時間の設定が完了していないようです！\nぜひ公式ページから設定をお願いします！\n設定ページ:\nhttps://zzzcrafter.fly.dev/users/edit"
    when Hash
      message_text = "登録が完了しました。\n就寝時間から逆算すると、 #{result[:recommend_time]}頃までには実践するのがオススメです！\n睡眠の質を高められるように頑張ってくださいね！"
    end

    LineMessagingService.send_reply(event['replyToken'], message_text)
  end

  def record_morning_condition(user, received_text, event)
    message_text = SleepRecord.record_condition(user.id, received_text)

    LineMessagingService.send_reply(event['replyToken'], message_text)
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
