class Richmenu < ApplicationRecord
  def self.postback_emulation(event)
    user_id = event['source']['userId']
    handle_postback(event, user_id)
  end

  private

  def self.handle_postback(event, user_id)
    # 必要な処理をここに実装

    send_line_message(user_id, "睡眠の記録を受け取りました。", event)
  end
  
  def self.send_line_message(user_id, message, event)
    message_content = {
      type: 'text',
      text: message
    }
    client.reply_message(event['replyToken'], message_content)
  end

  def self.client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
