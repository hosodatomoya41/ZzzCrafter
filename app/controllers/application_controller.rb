# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :require_login
  helper_method :logged_in?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # rubocop:disable Style/GuardClause
  def require_login
    unless current_user
      flash[:alert] = '先にログインをお願いします'
      redirect_to root_path
    end
  end
  # rubocop:enable Style/GuardClause

  def logged_in?
    !current_user.nil?
  end
end
