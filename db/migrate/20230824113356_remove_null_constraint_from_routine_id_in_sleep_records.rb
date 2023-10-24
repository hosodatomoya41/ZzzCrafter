# frozen_string_literal: true

class RemoveNullConstraintFromRoutineIdInSleepRecords < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sleep_records, :routine_id, true
  end
end
