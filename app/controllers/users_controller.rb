class UsersController < ApplicationController
  require 'net/http'
  require 'uri'
  
  def new
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
  
  def recommend_routines
    user = User.find_by(line_user_id: session[:line_user_id])
    issue_type = params[:issue_type].presence || user&.sleep_issue&.issue_type
  
    # issue_typeがparamsから来ている場合、それを@current_issue_typeに設定
    if params[:issue_type].present?
      @current_issue_type = params[:issue_type]
    # それ以外の場合、ユーザーが設定しているsleep_issue.idに対応するissue_typeを@current_issue_typeに設定
    elsif user.sleep_issue_id
      sleep_issue = SleepIssue.find_by(id: user.sleep_issue_id)
      @current_issue_type = sleep_issue.issue_type
    end
  
    if issue_type.present?
      sleep_issue = SleepIssue.find_by(issue_type: SleepIssue.issue_types[issue_type])
      if sleep_issue
        user.update!(sleep_issue_id: sleep_issue.id)
      end
    end
  
    @issue_types = SleepIssue.issue_types.keys
    @routines = if user.sleep_issue_id
      sleep_issue = SleepIssue.find_by(id: user.sleep_issue_id)
      sleep_issue ? sleep_issue.routines : Routine.none
    else
      Routine.all
    end
  
    @routines_before0 = @routines.where(recommend_time: 'before0')
    @routines_before1 = @routines.where(recommend_time: ['before1', 'before1_5'])
    @routines_before3 = @routines.where(recommend_time: ['before3', 'before10'])
  
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:bedtime, :notification_time)
  end
end
