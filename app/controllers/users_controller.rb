class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end

  def create
    # Strong Parameterを指定
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to VoyagePath!!"
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_profile_params)
      puts @user.errors.full_messages
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      puts @user.errors.full_messages
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

    # Strong Parameter設定（ログイン用）
    def user_params
      params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
    end

    # Strong Prameter設定（プロフィール更新用）
    def user_profile_params
      params.require(:user).permit(:user_name, :goal, :goal_due_date)
    end

end
