# frozen_string_literal: true

class AddSleepIssueIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sleep_issue_id, :integer
  end
end
