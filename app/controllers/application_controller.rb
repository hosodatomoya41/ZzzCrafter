class ApplicationController < ActionController::Base

  def not_authenticated
    flash[:danger] = "ログインが必要です"
    redirect_to login_path
  end
end
