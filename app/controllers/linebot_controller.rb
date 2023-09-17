class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery except: [:callback, :send_message]
  
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
    sleep_record = SleepRecord.where(user_id: user&.id).order("created_at DESC").first
    bedtime = sleep_record&.bedtime
    
    received_text = event.message['text']
    routine = Routine.find_by(line_text: received_text)
    recommend_time = calculate_recommend_time(bedtime, routine.recommend_time.to_sym)
        
    UserRoutine.create(
      user_id: user.id,
      routine_id: routine.id,
      choose_date: Date.today
    )
      message = {
        type: "text",
        text: "登録が完了しました。\n
就寝時間から逆算すると、 #{recommend_time}頃までには実践するのがオススメです！
睡眠の質を高められるように頑張ってくださいね！"
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
