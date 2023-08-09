class CreateSleepRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :routine, null: false, foreign_key: true
      t.date :record_date, null: false
      t.integer :morning_condition, null: false

      t.timestamps
    end
  end
end
