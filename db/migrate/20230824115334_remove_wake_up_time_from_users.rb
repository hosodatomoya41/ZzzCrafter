class RemoveWakeUpTimeFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :wake_up_time, :time
  end
end
