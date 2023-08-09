class IssueRoutine < ApplicationRecord
  belongs_to :sleep_issue
  belongs_to :routine

  validates :sleep_issue_id, :routine_id, presence: true
end
