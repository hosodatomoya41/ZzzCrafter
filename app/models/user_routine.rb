class UserRoutine < ApplicationRecord
  belongs_to :user
  belongs_to :routine

  validates :user_id, :routine_id, :choose_date, presence: true
end
