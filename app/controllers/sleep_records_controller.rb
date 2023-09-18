class SleepRecordsController < ApplicationController
  before_action :require_login
  before_action :set_user, only: [:new, :create]

  def index
    @user = User.find_by(line_user_id: session[:line_user_id])
    @sleep_records = current_user.sleep_records.order(record_date: :desc)
    @last_record = @user.bedtime
  end

  def new
    @sleep_record = @user.sleep_records.build
  end

  def create
    @sleep_record = @user.sleep_records.build(sleep_record_params)
    @sleep_record.record_date = Date.current
    @user.notification_time = params[:notification_time]
    if @sleep_record.save && @user.save
      flash[:success] = "睡眠記録が保存されました"
      redirect_to sleep_records_path
    else
      flash.now[:danger] = "睡眠記録の保存に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def sleep_record_params
    params.require(:sleep_record).permit(:record_date, :wake_up_time, :bedtime)
  end
end
