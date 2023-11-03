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
    user = User.find_by(line_user_id: event['source']['userId'])
    sleep_records = SleepRecord.where(user: user)

# Flex Messageの内容をsleep_recordから生成
message = {
  type: 'flex', 
  altText: '睡眠の記録一覧',
  contents: {
    type: 'bubble',
    body: {
      type: 'box',
      layout: 'vertical',
      contents: sleep_records.map do |record|
        {
          type: 'box',
          layout: 'horizontal',
          contents: [
            {
              type: 'text',
              text: record.record_date,
              size: 'sm',
              color: '#555555'
            },
            {
              type: 'text', 
              text: "起床: #{record.wake_up_time&.to_s(:time)}",
              size: 'sm',
              color: '#555555'
            },
            {
              type: 'text',
              text: "調子: #{condition_map[record.morning_condition]}",
              size: 'sm', 
              color: '#555555'
            }
          ]
        }
      end
    }

  }
}

  # 就寝時間と起床時間を登録する画面への遷移ボタンを含むメッセージ
  sleep_registration_message = {
    type: 'template',
    altText: '就寝時間と起床時間を登録',
    template: {
      type: 'buttons',
      title: '睡眠記録',
      text: '記録したい就寝時間と起床時間を選択してください。',
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

  # 送信するメッセージ群をclientに渡して送信する
  client.reply_message(event['replyToken'], [message, sleep_registration_message])

    send_line_message("睡眠の記録が完了しました。", event)
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
