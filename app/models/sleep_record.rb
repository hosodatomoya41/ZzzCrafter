class SleepRecord < ApplicationRecord
  belongs_to :user
  belongs_to :routine

  validates :user_id, :routine_id, :morning_condition, presence: true
end
