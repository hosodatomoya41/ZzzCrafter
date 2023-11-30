class RemoveRoutineIdFromSleepRecords < ActiveRecord::Migration[7.0]
  def change
    remove_column :sleep_records, :routine_id, :bigint
  end
end
