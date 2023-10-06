class ChangeUserIdToAllowNullInSleepIssues < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sleep_issues, :user_id, true
  end
end
