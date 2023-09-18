class RemoveBedtimeFromSleepRecords < ActiveRecord::Migration[7.0]
  def change
    remove_column :sleep_records, :bedtime, :time
  end
end
