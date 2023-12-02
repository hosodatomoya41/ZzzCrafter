# frozen_string_literal: true

class Richmenu < ApplicationRecord
  def self.postback(user, event, received_text)
    case received_text
    when '睡眠の記録を見る'
      handle_sleeprecord(event, user)
    when 'ルーティーン一覧を見る'
      handle_routines(event, user)
    when 'おすすめのルーティーンを教えて'
      handle_recommend_routines(event, user)
    end
  end

  def self.handle_sleeprecord(event, user)
    sleep_records ||= SleepRecord.grouped_by_date(Date.today.year, Date.today.month, user.id)

    message = {
      type: 'flex',
      altText: '睡眠の記録一覧',
      contents: {
        type: 'bubble',
        header: {
          type: 'box',
          layout: 'vertical',
          contents: [
            {
              type: 'text',
              text: "起床時間: #{user.notification_time&.strftime('%H:%M') || '未記録'}       就寝時間: #{user.bedtime&.strftime('%H:%M') || '未記録'}",
              weight: 'bold'
            },
            {
              type: 'separator'
            }
          ]
        },
        body: {
          type: 'box',
          layout: 'vertical',
          contents: if sleep_records.empty?
                      [{
                        type: 'text',
                        text: '記録がありません',
                        size: 'sm',
                        color: '#555555'
                      }]
                    else
                      sleep_records.map do |date, records|
                        record = records.first
                        {
                          type: 'box',
                          layout: 'horizontal',
                          contents: [
                            {
                              type: 'text',
                              text: date.to_s,
                              size: 'sm',
                              color: '#555555'
                            },
                            {
                              type: 'text',
                              text: "起床: #{record.wake_up_time&.strftime('%H:%M') || '未記録'}",
                              size: 'sm',
                              color: '#555555'
                            },
                            {
                              type: 'text',
                              text: "調子: #{SleepRecord::CONDITION_MAPPING[record.morning_condition] || '未記録'}",
                              size: 'sm',
                              color: '#555555'
                            }
                          ]
                        }
                      end
                    end
        },
        footer: {
          type: 'box',
          layout: 'vertical',
          contents: [
            {
              type: 'separator'
            },
            {
              type: 'text',
              text: "表示する年月をメッセージで送信することで選択できます。\n例:10月, 2022年10月",
              wrap: true
            }
          ]
        }
      }
    }

    sleep_registration_message = {
      type: 'template',
      altText: '起床時間と就寝時間の一覧',
      template: {
        type: 'buttons',
        title: '睡眠時間の記録',
        text: '目標の起床時間と就寝時間を設定できます。',
        actions: [
          {
            type: 'datetimepicker',
            label: '起床時間',
            data: 'action=wakeup&mode=datetime',
            mode: 'time'
          },
          {
            type: 'datetimepicker',
            label: '就寝時間',
            data: 'action=sleep&mode=datetime',
            mode: 'time'
          }
        ]
      }
    }
    client.reply_message(event['replyToken'], [message, sleep_registration_message])
  end

  def self.handle_routines(event, _user)
    buttons = [
      {
        type: 'postback',
        label: '就寝直前のルーティーン',
        data: 'action=show_routines&times[]=before0'
      },
      {
        type: 'postback',
        label: '就寝1時間前のルーティーン',
        data: 'action=show_routines&times[]=before1&times[]=before1_5'
      },
      {
        type: 'postback',
        label: '就寝3時間以上前のルーティーン',
        data: 'action=show_routines&times[]=before3&times[]=before10'
      }
    ]

    message = {
      type: 'template',
      altText: 'ルーティーン一覧',
      template: {
        type: 'buttons',
        title: 'ルーティーン一覧',
        text: '時間帯を選択してください',
        actions: buttons
      }
    }

    client.reply_message(event['replyToken'], [message])
  end

  def self.routines_index(routines, _event)
    {
      type: 'flex',
      altText: 'ルーティーン一覧',
      contents: {
        type: 'carousel',
        contents: routines.map do |routine|
          {
            type: 'bubble',
            size: 'kilo',
            body: {
              type: 'box',
              layout: 'vertical',
              contents: [
                {
                  type: 'text',
                  text: routine.name,
                  weight: 'bold',
                  size: 'xl'
                },
                {
                  type: 'text',
                  text: routine.description,
                  wrap: true
                }
              ]
            },
            footer: {
              type: 'box',
              layout: 'vertical',
              contents: [
                case routine.id
                when 1
                  {
                    type: 'button',
                    style: 'primary',
                    action: {
                      type: 'uri',
                      label: '動画を見る',
                      uri: 'https://www.youtube.com/watch?v=5bKFnxe9TU8'
                    }
                  }
                when 2
                  {
                    type: 'button',
                    style: 'primary',
                    action: {
                      type: 'uri',
                      label: '動画を見る',
                      uri: 'https://www.youtube.com/watch?v=kwDtQwrLD0Q'
                    }
                  }
                end,
                {
                  type: 'separator',
                  margin: 'md'
                },
                {
                  type: 'button',
                  style: 'primary',
                  action: {
                    type: 'postback',
                    label: 'このルーティーンを登録する',
                    data: "action=add_routine&routine_id=#{routine.id}"
                  }
                }
              ].compact
            }
          }
        end
      }
    }
  end

  def self.handle_recommend_routines(event, user)
    recommendations = user.recommend_routines
    messages = []

    # 最も高評価のルーティーンカルーセルを作成
    recommend_times = %w[before0 before1 before3]
    top_routines_carousel_items = []
    recommend_times.each do |time|
      next if recommendations[:top][time].nil? || recommendations[:top][time].empty?

      title = get_time_title(time)
      top_routines_carousel_items += recommendations[:top][time].map { |routine| create_routine_item(routine, title) }
    end

    unless top_routines_carousel_items.empty?
      top_routines_carousel_message = {
        type: 'flex',
        altText: '最も効果的だったルーティーン',
        contents: {
          type: 'carousel',
          contents: top_routines_carousel_items
        }
      }
      messages << top_routines_carousel_message
    end

    text = if recommendations[:top].values.all?(&:empty?)
             "翌朝の調子が良かった日に実践したルーティーンをご提案します！\n現在ではまだ記録がないようです。\n下記にいくつかルーティーンをご提案するので、取り組みやすそうなものがあったら取り組んでみてください！"
           else
             '上記が今までに実践して翌朝の調子が良かったルーティーンです！参考までに、下記のルーティーンも実践をご検討ください！'
           end
    text_message = {
      type: 'text',
      text: text
    }
    messages << text_message

    # [悪い]評価以外のルーティーンカルーセルを作成
    mid_routines_carousel_items = recommend_times.flat_map do |time|
      mid_key = "mid_#{time}"

      title = get_time_title(time)
      recommendations[:mid][mid_key].map { |routine| create_routine_item(routine, title) }
    end

    unless mid_routines_carousel_items.empty?
      mid_routines_message = {
        type: 'flex',
        altText: 'おすすめのルーティーン',
        contents: {
          type: 'carousel',
          contents: mid_routines_carousel_items
        }
      }
      messages << mid_routines_message
    end

    client.reply_message(event['replyToken'], messages) if messages.any?
  end

  def self.create_routines_carousel(routines, title)
    puts "create_routines_carousel called with: #{routines.inspect}"
    carousel_items = routines.map do |_time, routine_list|
      routine_list.map { |routine| create_routine_item(routine, title) }
    end.flatten

    {
      type: 'flex',
      altText: title,
      contents: {
        type: 'carousel',
        contents: carousel_items
      }
    }
  end

  def self.create_routine_item(routine, title)
    {
      type: 'bubble',
      header: {
        type: 'box',
        layout: 'vertical',
        contents: [
          {
            type: 'text',
            text: title,
            weight: 'bold',
            size: 'md'
          }
        ]
      },
      body: {
        type: 'box',
        layout: 'vertical',
        contents: [
          {
            type: 'text',
            text: routine.name,
            weight: 'bold',
            wrap: true
          },
          {
            type: 'text',
            text: routine.description,
            wrap: true,
            flex: 1,
            margin: 'md'
          }
        ],
        spacing: 'md',
        paddingAll: '12px'
      },
      footer: {
        type: 'box',
        layout: 'vertical',
        contents: [
          {
            type: 'button',
            style: 'primary',
            action: {
              type: 'postback',
              label: 'このルーティーンを登録する',
              data: "action=add_routine&routine_id=#{routine.id}"
            }
          }
        ]
      }
    }
  end

  def self.get_time_title(time)
    case time
    when 'before0'
      '就寝直前のルーティーン'
    when 'before1'
      '就寝1時間前のルーティーン'
    when 'before3'
      '就寝3時間以上前のルーティーン'
    else
      'ルーティーン'
    end
  end

  def self.client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
