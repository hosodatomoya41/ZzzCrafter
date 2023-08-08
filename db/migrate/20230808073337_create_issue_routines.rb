class CreateIssueRoutines < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_routines do |t|
      t.references :sleep_issue, null: false, foreign_key: true
      t.references :routine, null: false, foreign_key: true

      t.timestamps
    end
  end
end
