class SleepRecord < ApplicationRecord
  belongs_to :user
  belongs_to :routine, optional: true

  validates :user_id, presence: true
end
