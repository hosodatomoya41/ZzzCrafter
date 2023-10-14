class SleepRecordsController < ApplicationController
  before_action :require_login
  before_action :set_user, only: [:new, :create]

  def index
    @user = User.find(session[:user_id])
    
    if params[:month].present?
      @date = Date.parse(params[:month])
      @sleep_records = SleepRecord.where(record_date: @date.beginning_of_month..@date.end_of_month)
    else
      @sleep_records = SleepRecord.all
    end
    
    @sleep_records = current_user.sleep_records.order(record_date: :desc).page(params[:page]).per(31)
    @last_record = @user.bedtime
  end


  private

  def set_user
    @user = current_user
  end
end
