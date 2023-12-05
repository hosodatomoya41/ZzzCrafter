class RemoveUserIdFromSleepIssues < ActiveRecord::Migration[7.0]
  def change
    remove_reference :sleep_issues, :user, index: true, foreign_key: true
  end
end
