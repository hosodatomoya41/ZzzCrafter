namespace :wakeup_notify do
  desc "ユーザーがRoutineを登録すると、翌朝のnotification_timeにLINE通知が送られる"
  task send_notifications: :environment do
    today = Date.today

    User.find_each do |user|
      notification_time = user.notification_time
      current_time = Time.now.in_time_zone("Tokyo")
      has_registered_routine_today = user.user_routines.exists?(choose_date: today)

      # 現在の時間とユーザーの設定した通知時間の差分を計算
      time_difference = ((current_time - notification_time) / 60).abs  # 差分を分で計算

      # 現在の時間とユーザーの設定した通知時間が2分以内で一致するか、
      # そしてユーザーがその日にRoutineを登録しているかを確認
      if time_difference <= 2 && has_registered_routine_today
        Notification.send_wakeup_notification(user)
      end
    end
  end
end
