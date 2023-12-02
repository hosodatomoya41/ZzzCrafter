# frozen_string_literal: true

class LineMessagingService
  def self.send_reply(token, message_text)
    message = {
      type: 'text',
      text: message_text
    }
    client.reply_message(token, message)
  end

  def self.client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
