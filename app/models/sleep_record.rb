class SleepRecord < ApplicationRecord
  belongs_to :user
  belongs_to :routine

  validates :user_id, presence: true
end
