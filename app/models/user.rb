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
    return { status: :existing_routine, name: routine.name } if existing_routine?(routine)

    create_user_routine(routine)
    create_sleep_record

    return { status: :no_bedtime, name: routine.name } if bedtime.nil?

    recommend_time = calculate_time(bedtime, routine.recommend_time.to_sym)
    { status: :success, recommend_time: recommend_time, name: routine.name }
  end

  def routines_based_on_issue
    return Routine.all if sleep_issue_id == 1
    if sleep_issue_id
      sleep_issue = SleepIssue.find_by(id: sleep_issue_id)
      sleep_issue ? sleep_issue.routines : Routine.none
    else
      Routine.all
    end
  end

  def update_issue_type(issue_type)
    sleep_issue = SleepIssue.find_by(issue_type: SleepIssue.issue_types[issue_type])
    update!(sleep_issue_id: sleep_issue.id) if sleep_issue
  end

  def current_issue_type(params_issue_type)
    params_issue_type.presence || sleep_issue&.issue_type
  end

  def selected_issue_point
    if sleep_issue.present?
      issue_type = sleep_issue.issue_type
      SleepIssue::ISSUE_POINTS[issue_type.to_sym]
    else
      nil
    end
  end

  private

  def existing_routine?(routine)
    UserRoutine.exists?(user_id: id, routine_id: routine.id, choose_date: Date.today)
  end

  def create_user_routine(routine)
    UserRoutine.find_or_create_by(
      user_id: id,
      routine_id: routine.id,
      choose_date: Date.today
    )
  end

  def create_sleep_record
    SleepRecord.find_or_create_by(
      user_id: id,
      record_date: Date.tomorrow,
      morning_condition: nil
    )
  end
  
  def self.get_today_routine
    joins(:user_routines)
      .where(user_routines: { choose_date: Date.today })
      .where.not(bedtime: nil)
      .distinct
  end
end
