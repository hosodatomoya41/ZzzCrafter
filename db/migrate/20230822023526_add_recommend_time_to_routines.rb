# frozen_string_literal: true

class AddRecommendTimeToRoutines < ActiveRecord::Migration[7.0]
  def change
    add_column :routines, :recommend_time, :integer
  end
end
