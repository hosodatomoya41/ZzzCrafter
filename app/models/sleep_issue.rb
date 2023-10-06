class SleepIssue < ApplicationRecord
  belongs_to :user, optional: true
  has_many :issue_routines, dependent: :destroy
  has_many :routines, through: :issue_routines
  
  enum issue_type: {
    night_life: 0, 
    late_falling_asleep: 1, 
    waking_up_in_the_middle: 2 
  }
end
