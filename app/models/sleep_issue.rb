class SleepIssue < ApplicationRecord
  belongs_to :user
  has_many :issue_routines, dependent: :destroy

  validates :user_id, :issue_type, presence: true
  
  enum issue_type: {
    night_owl: 0,
    late_falling_asleep: 1,
    waking_up_in_the_middle: 2
  }
end
