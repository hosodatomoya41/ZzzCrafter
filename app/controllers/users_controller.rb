# frozen_string_literal: true

class UsersController < ApplicationController
  require 'net/http'
  require 'uri'
  before_action :require_login, only: %i[show routine_records recommend_routines]

  def new
    redirect_to root_path if current_user
  end

  def show
    @user = User.find(session[:user_id])
    @total_routine_count = @user.user_routines.count
    @total_date_count = @user.sleep_records.count

    set_year_and_month
    @grouped_user_routines = UserRoutine.grouped_by_date(@year, @month, current_user.id)
    @grouped_sleep_records = SleepRecord.grouped_by_date(@year, @month, current_user.id)
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    @user.update!(user_params)
    flash[:success] = '就寝時間と起床時間を登録しました'
    redirect_to sleep_records_path
  end

  def create
    id_token = params[:idToken]
    channel_id = ENV['CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),
                              { 'id_token' => id_token, 'client_id' => channel_id })
    line_user_id = JSON.parse(res.body)['sub']
    user = User.find_by(line_user_id: line_user_id)
    user = User.create(line_user_id: line_user_id) if user.nil?
    session[:user_id] = user.id
    render json: user
  end

  private

  def user_params
    params.require(:user).permit(:bedtime, :notification_time)
  end

  def set_year_and_month
    if params['month(1i)'].present? && params['month(2i)'].present?
      @year = params['month(1i)'].to_i
      @month = params['month(2i)'].to_i
    else
      @year = Date.today.year
      @month = Date.today.month
    end
  end

end
