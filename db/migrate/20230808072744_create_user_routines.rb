# frozen_string_literal: true

class CreateUserRoutines < ActiveRecord::Migration[7.0]
  def change
    create_table :user_routines do |t|
      t.references :user, null: false, foreign_key: true
      t.references :routine, null: false, foreign_key: true
      t.date :choose_date, null: false

      t.timestamps
    end
  end
end
