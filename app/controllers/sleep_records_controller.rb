class SleepRecordsController < ApplicationController
  before_action :set_user, only: [:new, :create]

  def index
    @sleep_records = SleepRecord.all
  end

  def new
    @sleep_record = @user.sleep_records.build
  end

  def create
    @user.update(bedtime: Time.parse(params[:bedtime]))
    @sleep_record = @user.sleep_records.build(sleep_record_params)

    if @sleep_record.save
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
    params.require(:sleep_record).permit(:record_date, :wake_up_time)
  end
end
