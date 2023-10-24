# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_routines, dependent: :destroy
  has_many :routines, through: :user_routines
  has_many :sleep_records, dependent: :destroy
  belongs_to :sleep_issue, optional: true

  validates :line_user_id, presence: true, uniqueness: true

  # 就寝時間とrecommend_timeに基づいて、推奨実践時間を計算
  def calculate_time(bedtime, recommend_time)
    offset = case recommend_time
             when :before0 then 0
             when :before1 then 1 * 60 * 60
             when :before1_5 then 1.5 * 60 * 60
             when :before3 then 3 * 60 * 60
             when :before10 then 10 * 60 * 60
             else 0
             end
    (bedtime - offset).strftime('%H:%M')
  end

  def register_routine(received_text)
    routine = Routine.find_by(line_text: received_text)
    existing_routine = UserRoutine.exists?(user_id: id, routine_id: routine.id, choose_date: Date.today)

    return :existing_routine if existing_routine

    UserRoutine.find_or_create_by(
      user_id: id,
      routine_id: routine.id,
      choose_date: Date.today
    )

    SleepRecord.find_or_create_by(
      user_id: id,
      record_date: Date.today,
      morning_condition: nil
    )

    return :no_bedtime if bedtime.nil?

    recommend_time = calculate_time(bedtime, routine.recommend_time.to_sym)
    { status: :success, recommend_time: recommend_time }
  end
end
