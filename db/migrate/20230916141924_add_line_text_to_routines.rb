# frozen_string_literal: true

class AddLineTextToRoutines < ActiveRecord::Migration[7.0]
  def change
    add_column :routines, :line_text, :string
  end
end
