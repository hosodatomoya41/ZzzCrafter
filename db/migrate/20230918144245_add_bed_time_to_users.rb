# frozen_string_literal: true

class AddBedTimeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :bedtime, :time unless column_exists?(:users, :bedtime)
  end
end
