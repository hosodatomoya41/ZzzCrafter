# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  belongs_to :user
  belongs_to :routine, optional: true

  validates :user_id, presence: true

  enum morning_condition: { good: 0, normal: 1, bad: 2 }

  CONDITION_MAPPING = {
    '調子は良い' => :good,
    '調子は普通' => :normal,
    '調子は悪い' => :bad
  }.freeze

  def self.record_condition(user_id, received_text)
    condition = CONDITION_MAPPING[received_text]
    record = find_by(user_id: user_id, record_date: Date.yesterday, morning_condition: nil)

    if record
      record.update(morning_condition: condition, wake_up_time: Time.current)
      '調子を記録しました。今日も一日頑張りましょう！'
    else
      '調子は記録済みです！今日も一日頑張りましょう！'
    end
  end
end
