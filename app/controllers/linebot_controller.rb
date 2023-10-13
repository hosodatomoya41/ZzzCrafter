class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery except: [:callback]
  
  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      return head :bad_request
    end
  
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          handle_message(event)
        end
      end
    end
  end
  
# 就寝時間とrecommend_timeに基づいて、推奨実践時間を計算
def calculate_recommend_time(bedtime, recommend_time)
  offset = case recommend_time
          when :before0 then 0
          when :before1 then 1 * 60 * 60
          when :before1_5 then 1.5 * 60 * 60
          when :before3 then 3 * 60 * 60
          when :before10 then 10 * 60 * 60
          else 0
          end
  (bedtime - offset).strftime("%H:%M")
end
  
  private

  def handle_message(event)
    line_user_id = event['source']['userId']
    user = User.find_by(line_user_id: line_user_id)
    
    received_text = event.message['text']
  
    if received_text == "調子は良い" || received_text == "調子は普通" || received_text == "調子は悪い"
      record_morning_condition(user, received_text, event)
    else
      register_routine(user, received_text, event)
    end
  end
  
  def register_routine(user, received_text, event)
    bedtime = user&.bedtime
    routine = Routine.find_by(line_text: received_text)
    
  # 既に当日に同じroutineが登録されているか確認
  existing_routine = UserRoutine.exists?(user_id: user.id, routine_id: routine.id, choose_date: Date.today)

  if existing_routine
    message = {
      type: "text",
      text: "既にそのルーティーンは本日登録されたようです！\n継続は力なり、がんばってくださいね！"
    }
    client.reply_message(event['replyToken'], message)
    return
  end

    UserRoutine.find_or_create_by(
      user_id: user.id,
      routine_id: routine.id,
      choose_date: Date.today
    )
    
    SleepRecord.find_or_create_by(
      user_id: user.id,
      record_date: Date.today,
      morning_condition: nil
    )
  
    if bedtime.nil?
      message = {
        type: "text",
        text: "登録が完了しました！\nまだ就寝時間の設定が完了していないようです！\nぜひ公式ページから設定をお願いします！\n設定ページ:\nhttps://zzzcrafter.fly.dev/users/edit"
      }
      client.reply_message(event['replyToken'], message)
      return
    end
  
    recommend_time = calculate_recommend_time(bedtime, routine.recommend_time.to_sym)

    message = {
      type: "text",
      text: "登録が完了しました。\n
就寝時間から逆算すると、 #{recommend_time}頃までには実践するのがオススメです！\n
睡眠の質を高められるように頑張ってくださいね！"
    }
    client.reply_message(event['replyToken'], message)
  end
  
  def record_morning_condition(user, received_text, event)
    condition = case received_text
                when "調子は良い" then "good"
                when "調子は普通" then "normal"
                when "調子は悪い" then "bad"
                end

    record = SleepRecord.find_by(user_id: user.id, record_date: Date.yesterday, morning_condition: nil)
    if record
      current_time = Time.current
      record.update(morning_condition: condition, wake_up_time: current_time)
    end
  
    message = {
      type: "text",
      text: "調子を記録しました。今日も一日頑張りましょう！"
    }
    client.reply_message(event['replyToken'], message)
  end
  
  
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end