class SleepIssue < ApplicationRecord
  belongs_to :user
  has_many :issue_routines, dependent: :destroy

  validates :user_id, :issue_type, presence: true
end
