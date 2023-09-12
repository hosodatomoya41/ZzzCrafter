class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(line_user_id: session[:line_user_id]) if session[:line_user_id]
  end
end
