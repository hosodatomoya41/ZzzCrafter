class CreateSleepIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_issues do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :issue_type, null: false

      t.timestamps
    end
  end
end
