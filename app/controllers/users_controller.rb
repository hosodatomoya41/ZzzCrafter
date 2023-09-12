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
    @total_routine_count = @user.sleep_records.count
    @total_date_count = @user.sleep_records.count
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
  
  def logout_success; end
  
  def destroy
    session.delete(:line_user_id)
    redirect_to logout_success_path
  end
end
