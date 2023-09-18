namespace :wakeup_notify do
  desc "ユーザーがRoutineを登録すると、翌朝のwake_up_timeにLINE通知が送られる"
  task send_notifications: :environment do
    # 現在の日付を取得
    today = Date.today

    # すべてのユーザーをループ
    User.find_each do |user|
      # ユーザーが設定したwake_up_timeを取得
      wake_up_time = user.notification_time

      # 現在の時間とwake_up_timeを比較
      current_time = Time.now
      if current_time.strftime("%H:%M") == wake_up_time.strftime("%H:%M")
        # 今日登録されたRoutineを取得
        routines = user.routines.where(created_at: today.beginning_of_day..today.end_of_day)

        line_text = "おはようございます！起床時間となりました！今の調子をざっくりと良いので教えてください！今日も一日頑張りましょう！"

        Notification.send_wakeup_message(user.line_user_id, line_text, routines)
      end
    end
  end
end
