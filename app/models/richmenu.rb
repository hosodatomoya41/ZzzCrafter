class Richmenu < ApplicationRecord
  def self.postback(user, event, received_text)
    if received_text == "睡眠の記録を見る"
      handle_sleeprecord(event, user, sleep_records = nil)
    elsif received_text == "ルーティーン一覧を見る"
      handle_routines(event, user)
    elsif received_text == "おすすめのルーティーンを教えて"
      handle_recommend_routines(event, user)
    else
      handle_how_to_use(event)
    end
  end

  private

  def self.handle_sleeprecord(event, user, sleep_records = nil)
    sleep_records ||= SleepRecord.grouped_by_date(Date.today.year, Date.today.month, user.id)
    puts "Debug: Inside handle_sleeprecord: #{sleep_records.inspect}" 

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
              text: "就寝時間: #{user.bedtime&.strftime('%H:%M') || '未記録'}       起床時間: #{user.notification_time&.strftime('%H:%M') || '未記録'}",
              weight: 'bold',
            }
          ]
        },
        body: {
          type: 'box',
          layout: 'vertical',
          contents: sleep_records.map { |date, records|
          puts "Debug: Date: #{date}, Records: #{records.inspect}"  # デバッグ出力
          record = records.first
          puts "Debug: First Record: #{record.inspect}"
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
                  text: "調子: #{condition_map[record.morning_condition] || '未記録'}",
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
              type: 'text',
              text: '表示する月を選択してください。',
              wrap: true
            },
            {
              type: 'button',
              action: {
                type: 'postback',
                label: '月を選択',
                data: 'action=select_month'
              },
              margin: 'sm',
              height: 'sm',
              style: 'primary'
            }
          ]
        }
      }
    }


  # 就寝時間と起床時間を登録する画面への遷移ボタンを含むメッセージ
  sleep_registration_message = {
    type: 'template',
    altText: '就寝時間と起床時間の一覧',
    template: {
      type: 'buttons',
      title: '睡眠時間の記録',
      text: '目標の就寝時間と起床時間を選択してください。',
      actions: [
        {
          type: 'datetimepicker',
          label: '就寝時間',
          data: 'action=sleep&mode=datettime',
          mode: 'time'
        },
        {
          type: 'datetimepicker',
          label: '起床時間',
          data: 'action=wakeup&mode=datettime',
          mode: 'time'
        }
      ]
    }
  }
  client.reply_message(event['replyToken'], [message, sleep_registration_message])
  end
  
  def self.handle_routines(event, user)
    send_line_message("ルーティーン一覧を受け取りました。", event)
  end
  
  def self.handle_recommend_routines(event, user)
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

  def self.condition_map
    {
      "good" => "良い",
      "normal" => "普通",
      "bad" => "悪い"
    }
  end

  def self.client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
