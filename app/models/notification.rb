# frozen_string_literal: true

class Notification < ApplicationRecord
  require 'line/bot'

  def self.send_wakeup_notification(user)
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
  
  def self.send_routine_notification(user, user_routine, recommend_time, bedtime)
    routines = user_routine.join(', ')

    if recommend_time == bedtime
      line_text = 
        "【#{routines}】の実践時間となりました！\nそして、就寝時間となったので、【#{routines}】の実践が完了したら就寝し、翌朝の調子を観察してみてください。\n本日もお疲れ様でした！"
    else
      line_text =
        "【#{routines}】の実践時間となりました！\n取り組みやすいものは習慣化させ、睡眠の質を高めていけるように頑張ってくださいね！"
    end
    
    messages = [
      { type: 'text', text: line_text }
    ]
    client.push_message(user.line_user_id, messages)
  end

  def self.client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
