namespace :routine_notify do
  desc 'ユーザーに設定されたrecommend_timeの時間にルーティーン実践の催促の通知を送る'
  task send_notifications: :environment do
    User.get_today_routine.find_each do |user|
      current_time = Time.now.in_time_zone('Tokyo').strftime('%H:%M')
      bedtime = user.bedtime.strftime('%H:%M')
      user_routines_to_notify = []

      user.user_routines.where(choose_date: Date.today).includes(:routine).each do |user_routine|
        recommended_notify_time = user.calculate_time(user.bedtime, user_routine.routine.recommend_time.to_sym)
        if recommended_notify_time == current_time
          user_routines_to_notify << user_routine.routine.name
        end
      end

      unless user_routines_to_notify.empty?
        Notification.send_routine_notification(user, user_routines_to_notify, current_time, bedtime)
      end
    end
  end
end
