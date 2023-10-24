# frozen_string_literal: true

class CreateRoutines < ActiveRecord::Migration[7.0]
  def change
    create_table :routines do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.time :recommend_time, null: false

      t.timestamps
    end
  end
end
