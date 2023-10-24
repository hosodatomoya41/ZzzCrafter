# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  belongs_to :user
  belongs_to :routine, optional: true

  validates :user_id, presence: true

  enum morning_condition: { good: 0, normal: 1, bad: 2 }
end
