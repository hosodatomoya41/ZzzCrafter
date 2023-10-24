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
          { type: 'message', label: '調子は良い', text: '調子は良い' },
          { type: 'message', label: '調子は普通', text: '調子は普通' },
          { type: 'message', label: '調子は悪い', text: '調子は悪い' }
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
