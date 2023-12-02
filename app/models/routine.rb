# frozen_string_literal: true

class Routine < ApplicationRecord
  has_many :user_routines, dependent: :destroy
  has_many :users, through: :user_routines
  has_many :issue_routines, dependent: :destroy
  has_many :sleep_issues, through: :issue_routines
  has_many :sleep_records, dependent: :destroy

  validates :name, :description, :recommend_time, presence: true

  enum recommend_time: { before0: 0, before1: 1, before1_5: 15, before3: 3, before10: 10 }

  def self.get_routines(time)
    Routine.where(recommend_time: time)
  end

  def self.get_messages(routine, result, event)
    video_url = get_videos(routine)
    footer_contents = build_footer_contents(video_url)
    text = build_message_text(result)

    message_text = {
      type: 'flex',
      altText: 'ルーティーン登録',
      contents: build_message_contents(text, footer_contents)
    }

    client.reply_message(event['replyToken'], message_text)
  end

  def self.build_footer_contents(video_url)
    return [] unless video_url

    [{
      type: 'button',
      style: 'primary',
      action: {
        type: 'uri',
        label: '動画を見る',
        uri: video_url
      }
    }]
  end

  def self.build_message_text(result)
    case result[:status]
    when :existing_routine
      "既に【#{result[:name]}】は本日登録されたようです！\n継続は力なり、がんばってくださいね！"
    when :no_bedtime
      "【#{result[:name]}】を登録しました。\n就寝時間の設定をして頂くと、ルーティーンの実践に適正な時間が分かります！\nぜひ、メニューの【睡眠の記録】から就寝時間の設定をしてみてください！"
    when :success
      "【#{result[:name]}】を登録しました。\n就寝時間から逆算すると、 #{result[:recommend_time]}頃に実践するのがオススメです！\n睡眠の質を高められるように頑張ってくださいね！"
    end
  end

  def self.build_message_contents(text, footer_contents)
    {
      type: 'bubble',
      size: 'mega',
      body: {
        type: 'box',
        layout: 'vertical',
        contents: [{
          type: 'text',
          text: text,
          wrap: true
        }]
      },
      footer: {
        type: 'box',
        layout: 'vertical',
        contents: footer_contents
      }
    }
  end

  def self.get_videos(routine)
    case routine.id
    when 1
      'https://www.youtube.com/watch?v=5bKFnxe9TU8'
    when 2
      'https://www.youtube.com/watch?v=kwDtQwrLD0Q'
    end
  end

  def self.client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
