class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(current_user.id)
    @total_routine_count = @user.sleep_records.count
    @total_date_count = @user.sleep_records.count
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "新規登録に成功しました"
      redirect_to root_path
    else
      flash.now[:danger] = "新規登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
