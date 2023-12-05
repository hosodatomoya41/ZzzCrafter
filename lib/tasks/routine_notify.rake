# frozen_string_literal: true

namespace :routine_notify do
  desc 'ユーザーに設定されたルーティーンの推奨実践時間にルーティーン実践の催促の通知送信'
  task send_notifications: :environment do
    # 今日ルーティンを登録しているユーザーごとに実行
    User.today_routine.find_each do |user|
      current_time = Time.now.in_time_zone('Tokyo').strftime('%H:%M')
      # ユーザーの就寝時間を取得
      bedtime = user.bedtime.strftime('%H:%M')
      user_routines_to_notify = []

      user.user_routines.includes(:routine).each do |user_routine|
        # ルーティンが今日実行されるものかどうかをチェック
        if user_routine.choose_date == appropriate_date(user_routine, user_routine.routine.recommend_time.to_sym)
          # 通知を送るべき時間を計算
          recommended_notify_time = user.calculate_time(user.bedtime, user_routine.routine.recommend_time.to_sym)
          # 現在時間が通知時間と一致する場合、通知配列にルーティン名を追加
          user_routines_to_notify << user_routine.routine.name if recommended_notify_time == current_time
        end
      end

      Notification.send_routine_notification(user, user_routines_to_notify, current_time, bedtime) unless user_routines_to_notify.empty?
    end
  end

  def appropriate_date(user_routine, recommend_time)
    # 就寝時間が0:00以降でも適切に通知を送るためのメソッド
    # ユーザーの就寝時間を取得
    bedtime = user_routine.user.bedtime.strftime('%H:%M')
  
    if bedtime >= '00:00' && bedtime <= '00:59'
      # ルーティーン実践時間が0:00以降で就寝時間と同じ時間の場合、日程を昨日に設定
      recommend_time == :before0 ? Date.yesterday : Date.today
    elsif bedtime > '00:59' && bedtime < '06:00'
      # 就寝時間が1時以降でルーティーン実践時間が0:00以降の場合、日程を昨日に設定
      [:before0, :before1].include?(recommend_time) ? Date.yesterday : Date.today
    else
      Date.today
    end
  end
end
