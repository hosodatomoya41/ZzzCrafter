# frozen_string_literal: true

class RemoveRecommendTimeFromRoutines < ActiveRecord::Migration[7.0]
  def change
    remove_column :routines, :recommend_time, :string
  end
end
