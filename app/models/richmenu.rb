class Richmenu < ApplicationRecord
  def self.postback(user, event, received_text)
    if received_text == "睡眠の記録を見る"
      handle_sleeprecord(event, user, sleep_records = nil)
    elsif received_text == "ルーティーン一覧を見る"
      handle_routines(event, user)
    elsif received_text == "おすすめのルーティーンを教えて"
      handle_recommend_routines(event, user)
    end
  end

  private

  def self.handle_sleeprecord(event, user, sleep_records = nil)
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
              weight: 'bold',
            },
            {
              type: 'separator',
            }
          ]
        },
        body: {
          type: 'box',
          layout: 'vertical',
          contents: sleep_records.empty? ? 
            [{
              type: 'text',
              text: '記録がありません',
              size: 'sm',
              color: '#555555'
            }] : 
            sleep_records.map { |date, records|
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
            }
        },
        footer: {
          type: 'box',
          layout: 'vertical',
          contents: [
            {
              type: 'separator',
            },
            {
              type: 'text',
              text: "表示する年月をチャットで送信することで選択できます。\n例:10月, 2022年10月",
              wrap: true
            },
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
  
  def self.handle_routines(event, user)
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
  
  def self.routines_index(routines, event)
    message = {
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
                {
                  type: 'button',
                  style: 'primary',
                  action: {
                    type: 'postback',
                    label: 'このルーティーンを追加',
                    data: "action=add_routine&routine_id=#{routine.id}"
                  }
                }
              ]
            }
          }
        end
      }
    }
  end
  
  def self.handle_recommend_routines(event, user)
    LineMessagingService.send_reply(event['replyToken'], "おすすめのルーティーンを受け取りました")
  end
  
  def self.client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
