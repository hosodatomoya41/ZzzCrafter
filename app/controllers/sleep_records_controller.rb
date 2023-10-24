# frozen_string_literal: true

class SleepRecordsController < ApplicationController
  before_action :require_login
  before_action :set_user, only: %i[new create]

  def index
    @user = User.find(session[:user_id])

    if params['month(1i)'].present? && params['month(2i)'].present?
      @year = params['month(1i)'].to_i
      @month = params['month(2i)'].to_i
    else
      @year = Date.today.year
      @month = Date.today.month
    end

    start_date = Date.new(@year, @month, 1)
    end_date = start_date.end_of_month

    @sleep_records = SleepRecord.where(user_id: current_user.id)
                                .where(record_date: start_date..end_date)
                                .order(record_date: :desc)
    @last_record = @user.bedtime
  end

  private

  def set_user
    @user = current_user
  end
end
