namespace :routine_notify do
  desc 'ユーザーに設定されたrecommend_timeの時間にルーティーン実践の催促の通知を送る'
  task send_notifications: :environment do
    User.get_today_routine.find_each do |user|
      current_time = Time.now.in_time_zone('Tokyo').strftime('%H:%M')
      bedtime = user.bedtime.strftime('%H:%M')

      # 当日選択されたルーティーンの中で、現在の時間に一致するrecommend_timeを持つものを収集
      routines_to_notify = user.user_routines.where(choose_date: Date.today).includes(:routine).select do |user_routine|
        user.calculate_time(user.bedtime, user_routine.routine.recommend_time.to_sym) == current_time
      end

      unless routines_to_notify.empty?
        user_routine_names = routines_to_notify.map { |ur| ur.routine.name }
        Notification.send_routine_notification(user, user_routine_names, current_time, bedtime)
      end
    end
  end
end
