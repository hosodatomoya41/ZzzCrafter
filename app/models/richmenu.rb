class Richmenu < ApplicationRecord
  def self.postback(event, received_text)
    user_id = event['source']['userId']
    if received_text == "睡眠の記録を見る"
      handle_sleeprecord(event, user_id)
    elsif received_text == "ルーティーン一覧を見る"
      handle_routines(event, user_id)
    elsif received_text == "おすすめのルーティーンを教えて"
      handle_recommend_routines(event, user_id)
    else
      handle_how_to_use(event)
    end
  end

  private

  def self.handle_sleeprecord(event, user_id)
    # 必要な処理をここに実装

    send_line_message("睡眠の記録を受け取りました。", event)
  end
  
  def self.handle_routines(event, user_id)
    send_line_message("ルーティーン一覧を受け取りました。", event)
  end
  
  def self.handle_recommend_routines(event, user_id)
    send_line_message("おすすめのルーティーンを受け取りました。", event)
  end

  def self.handle_how_to_use(event)
    send_line_message("使い方", event)
  end
  
  def self.send_line_message(message, event)
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
