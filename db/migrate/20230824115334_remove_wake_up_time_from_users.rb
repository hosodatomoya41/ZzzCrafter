# frozen_string_literal: true

class RemoveWakeUpTimeFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :wake_up_time, :time
    remove_column :users, :bedtime, :time
  end
end
