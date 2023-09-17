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
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end
  end
  
  def send_message
    line_user_id = params[:line_user_id]
    message = params[:message]

    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    message = {
      type: 'text',
      text: message
    }

    response = client.push_message(line_user_id, message)
    render json: { status: 'success' }
  end
  
  def qr_code
    @routines = Routine.all
  end
  
  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
