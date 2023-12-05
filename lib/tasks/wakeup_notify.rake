# frozen_string_literal: true

namespace :wakeup_notify do
  desc 'ユーザーがルーティーンを登録すると、翌朝の起床時間にLINE通知を送信'
  task send_notifications: :environment do
    today = Date.today

    User.where.not(notification_time: nil).find_each do |user|
      current_time = Time.now.in_time_zone('Tokyo').strftime('%H:%M')
      # ユーザーの通知時間を取得
      notification_time = user.notification_time.strftime('%H:%M')
      # ユーザーがルーティーンを登録しているか確認
      has_registered_routine = user.user_routines.exists?(choose_date: today - 1)

      Notification.send_wakeup_notification(user) if current_time == notification_time && has_registered_routine
    end
  end
end
