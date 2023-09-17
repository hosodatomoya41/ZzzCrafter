class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery except: [:callback, :send_message]
  
  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      return head :bad_request
    end
    
    validation_result = client.validate_signature(body, signature)
    Rails.logger.info "Validation result: #{validation_result}" 
  
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
  
  def calculate_recommend_time(bedtime)
  # 最適な実践時間を計算（例：就寝時間の2時間前）
    (bedtime - 2 * 60 * 60).strftime("%H:%M")
  end
  
  private

  def handle_message(event)
    line_user_id = event['source']['userId']
    user = User.find_by(line_user_id: line_user_id)
    Rails.logger.info "User ID: #{user&.id}"
  
    sleep_record = SleepRecord.where(user_id: user&.id).order("created_at DESC").first
    Rails.logger.info "Sleep Record: #{sleep_record.inspect}"
    bedtime = sleep_record&.bedtime

    if event.message['text'] == "瞑想を追加しました"
      recommend_time = calculate_recommend_time(bedtime)
      message = {
        type: "text",
        text: "最適な実践時間は #{recommend_time} です"
      }
      client.reply_message(event['replyToken'], message)
    end
  end
  
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
