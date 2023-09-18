class UsersController < ApplicationController
  require 'net/http'
  require 'uri'
  
  def new
    if session[:line_user_id]
      redirect_to root_path
    end
  end

  def show
    @user = User.find_by(line_user_id: session[:line_user_id])
    @total_routine_count = @user.user_routines.count
    @total_date_count = @user.sleep_records.count
  end
  
  def edit
    @user = User.find_by(line_user_id: session[:line_user_id])
  end

  def update
    @user = User.find_by(line_user_id: session[:line_user_id])
    if @user.update(user_params)
      flash[:success] = "睡眠記録が保存されました"
      redirect_to sleep_records_path
    else
      flash.now[:danger] = "睡眠記録の保存に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    id_token = params[:idToken]
    channel_id = ENV['CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'), { 'id_token' => id_token, 'client_id' => channel_id })
    line_user_id = JSON.parse(res.body)['sub']
    user = User.find_by(line_user_id: line_user_id)
    if user.nil?
      user = User.create(line_user_id: line_user_id)
    end
    session[:line_user_id] = line_user_id
    render json: user
  end
  
  def routine_records
    @user = User.find_by(line_user_id: session[:line_user_id])
    
    @grouped_user_routines = UserRoutine.order('choose_date DESC')
                                        .group_by { |ur| ur.choose_date }
  
    @grouped_sleep_records = SleepRecord.where(user_id: current_user.id)
                                        .order('record_date DESC')
                                        .group_by { |record| record.record_date }
  end
  
  private

  def user_params
    params.require(:user).permit(:bedtime, :notification_time)
  end
end
