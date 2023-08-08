class IssueRoutine < ApplicationRecord
  belongs_to :sleep_issue
  belongs_to :routine
end
