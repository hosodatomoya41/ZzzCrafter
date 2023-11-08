# frozen_string_literal: true

class Notification < ApplicationRecord
  require 'line/bot'

  def self.send_wakeup_notification(user)
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end

    line_text =
      "おはようございます！起床時間となりました！
今の調子をざっくりで良いので教えてください！"

    buttons = {
      type: 'template',
      altText: '調子はどうですか？',
      template: {
        type: 'buttons',
        text: '調子はどうですか？',
        actions: [
          {
            type: 'postback',
            label: '良い',
            data: 'action=good',
            displayText: '良い'
          },
          {
            type: 'postback',
            label: '普通',
            data: 'action=normal',
            displayText: '普通'
          },
          {
            type: 'postback',
            label: '悪い',
            data: 'action=bad',
            displayText: '悪い'
          }
        ]
      }
    }


    messages = [
      { type: 'text', text: line_text },
      buttons
    ]

    client.push_message(user.line_user_id, messages)
  end
end
