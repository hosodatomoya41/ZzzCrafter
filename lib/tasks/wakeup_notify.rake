namespace :wakeup_notify do
  desc "ユーザーがRoutineを登録すると、翌朝のnotification_timeにLINE通知が送られる"
  task send_notifications: :environment do
    today = Date.today

    User.find_each do |user|
      notification_time = user.notification_time
      current_time = Time.now.strftime("%H:%M")
      has_registered_routine_today = user.user_routines.exists?(choose_date: today)

      # 現在の時間とユーザーの設定した通知時間が一致するか、
      # そしてユーザーがその日にRoutineを登録しているかを確認
      if current_time == notification_time.strftime("%H:%M") && has_registered_routine_today
        Notification.send_wakeup_notification(user)
      end
    end
  end
end
