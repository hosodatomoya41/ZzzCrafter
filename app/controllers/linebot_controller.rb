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
    params = Rack::Utils.parse_nested_query(data)
    case params['action']
    when 'select_month'
      # ユーザーに月の入力を促すメッセージを送信
      message = {
        type: 'text',
        text: '1月から12月までの数字で月を入力してください。例: 1月'
      }
      client.reply_message(event['replyToken'], message)
    end
  end

  def handle_message(event)
    line_user_id = event['source']['userId']
    user = User.find_by(line_user_id: line_user_id)

    received_text = event.message['text']

    if %w[調子は良い 調子は普通 調子は悪い].include?(received_text)
      record_morning_condition(user, received_text, event)
    elsif %w[睡眠の記録を見る ルーティーン一覧を見る おすすめのルーティーンを教えて アプリの使い方].include?(received_text)
      Richmenu.postback(user, event, received_text)
    elsif received_text =~ /^(1[0-2]|0?[1-9])月$/
      handle_month(user, event, received_text)
    else
      register_routine(user, received_text, event)
    end
  end
  
  def handle_month(user, event, received_text)
    # 現在の年を取得
    current_year = Date.today.year
  
    # ユーザーが年を指定しているかチェック
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
    puts "Debug: Start Date: #{start_date}, End Date: #{end_date}"
    
    sleep_records = SleepRecord.fetch_records(user.id, start_date, end_date)
    puts "Debug: Sleep Records: #{sleep_records.inspect}"
    grouped_sleep_records = sleep_records.group_by(&:record_date)
    
    # 取得したデータをもとにFlex Messageを生成して送信
    message = Richmenu.handle_sleeprecord(event, user, grouped_sleep_records)
    response_message = {
      type: 'text',
      text: "#{year}年#{month}月のデータを取得しました。"
    }
    # ユーザーに応答メッセージを送信
    client.reply_message(event['replyToken'], [message, response_message]) 
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

    message = {
      type: 'text',
      text: message_text
    }
    client.reply_message(event['replyToken'], message)
  end

  def record_morning_condition(user, received_text, event)
    message_text = SleepRecord.record_condition(user.id, received_text)

    message = {
      type: 'text',
      text: message_text
    }
    client.reply_message(event['replyToken'], message)
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
