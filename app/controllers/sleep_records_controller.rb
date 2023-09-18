class SleepRecordsController < ApplicationController
  before_action :require_login
  before_action :set_user, only: [:new, :create]

  def index
    @user = User.find_by(line_user_id: session[:line_user_id])
    @sleep_records = current_user.sleep_records.order(record_date: :desc)
    @last_record = @user.bedtime
  end


  private

  def set_user
    @user = current_user
  end
end
