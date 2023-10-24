# frozen_string_literal: true

class ChangeMorningConditionInSleepRecords < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sleep_records, :morning_condition, true
  end
end
