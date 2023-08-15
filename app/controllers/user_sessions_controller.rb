class UserSessionsController < ApplicationController
  
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to root_path, success: "ログインしました"
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = "ログアウトしました"
    redirect_to root_path  
  end

end
