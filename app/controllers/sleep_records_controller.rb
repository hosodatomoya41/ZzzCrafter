class SleepRecordsController < ApplicationController
  def index
    @sleep_records = SleepRecord.all
  end

  def new
    @user = current_user
    @sleep_record = @user.sleep_records.build
  end

  def create
    @user = current_user
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

  def sleep_record_params
    params.require(:sleep_record).permit(:record_date, :wake_up_time)
  end
  end
