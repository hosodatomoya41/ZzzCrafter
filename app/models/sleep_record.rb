# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  belongs_to :user
  belongs_to :routine, optional: true

  validates :user_id, presence: true

  enum morning_condition: { good: 0, normal: 1, bad: 2 }

  CONDITION_MAPPING = {
    'good' => '良い',
    'normal' => '普通',
    'bad' => '悪い'
  }.freeze

  def self.record_condition(user_id, received_text)
    condition = received_text
    record = find_by(user_id: user_id, record_date: Date.today, morning_condition: nil)

    if record
      if morning_conditions.keys.include?(condition)
        record.update(morning_condition: morning_conditions[condition], wake_up_time: Time.current)
        '調子を記録しました。今日も一日頑張りましょう！'
      end
    else
      '調子は記録済みです！今日も一日頑張りましょう！'
    end
  end

  def self.fetch_records(user_id, start_date, end_date)
    where(user_id: user_id)
      .where(record_date: start_date..end_date)
      .order(record_date: :desc)
  end

  def self.determine_date_range(params)
    year, month = if params['month(1i)'].present? && params['month(2i)'].present?
                    [params['month(1i)'].to_i, params['month(2i)'].to_i]
                  else
                    [Date.today.year, Date.today.month]
                  end
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    [start_date, end_date, year, month]
  end

  def self.grouped_by_date(year, month, user_id)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    where(user_id: user_id, record_date: start_date..end_date)
      .order('record_date DESC')
      .group_by(&:record_date)
  end

  def user_routines
    user.user_routines.where(choose_date: record_date)
  end
end
