class Notification < ApplicationRecord
  def self.send_wakeup_notification(user)

    # ステップ2: 通知内容の生成
    line_text = "おはようございます！起床時間となりました！今の調子をざっくりと良いので教えてください！今日も一日頑張りましょう！"
    buttons = [
      { "type": "message", "label": "調子は良い", "text": "調子は良い" },
      { "type": "message", "label": "調子は普通", "text": "調子は普通" },
      { "type": "message", "label": "調子は悪い", "text": "調子は悪い" }
    ]

    # ステップ3: API呼び出し
    response = HTTParty.post("https://api.line.me/v2/bot/message/push",
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{ENV['LINE_CHANNEL_TOKEN']}"
      },
      body: {
        to: user.line_user_id,
        messages: [
          {
            type: "text",
            text: line_text
          },
          {
            type: "template",
            altText: "調子はどうですか？",
            template: {
              type: "buttons",
              text: "調子はどうですか？",
              actions: buttons
            }
          }
        ]
      }.to_json
    )

    if response.code == 200
      puts "Successfully sent notification."
    else
      puts "Failed to send notification. Response: #{response.body}"
    end

  end
end
