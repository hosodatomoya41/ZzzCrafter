class AddWakeUpTimeToSleepRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :sleep_records, :wake_up_time, :time
  end
end
