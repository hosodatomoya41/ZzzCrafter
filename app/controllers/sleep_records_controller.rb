# frozen_string_literal: true

class SleepRecordsController < ApplicationController
  before_action :require_login
  before_action :set_user, only: %i[new create]
  before_action :set_date

  def index
    @sleep_records = SleepRecord.fetch_records(current_user.id, @start_date, @end_date)
    @last_record = current_user.bedtime
  end

  private

  def set_user
    @user = current_user
  end

  def set_date
    @start_date, @end_date, @year, @month = SleepRecord.determine_date_range(params)
  end
end
