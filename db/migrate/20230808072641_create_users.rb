# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.time :bedtime
      t.time :wake_up_time
      t.time :notification_time

      t.timestamps null: false
    end
  end
end
