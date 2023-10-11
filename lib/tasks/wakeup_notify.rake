namespace :wakeup_notify do
  desc "ユーザーがRoutineを登録すると、翌朝のnotification_timeにLINE通知が送られる"
  task send_notifications: :environment do
    today = Date.today

    User.where.not(notification_time: nil).find_each do |user|
      current_time = Time.now.in_time_zone("Tokyo")  # 現在の時間を取得
      notification_time = user.notification_time.in_time_zone("Tokyo")  # ユーザーの通知時間を取得

      # 時、分、秒だけを取得
      current_time_str = current_time.strftime("%M")
      notification_time_str = notification_time.strftime("%M")
      has_registered_routine = user.user_routines.exists?(choose_date: today - 1)

      if current_time_str == notification_time_str && has_registered_routine
        Notification.send_wakeup_notification(user)
      end
    end
  end
end
