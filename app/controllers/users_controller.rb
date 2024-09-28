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
  end

  def update
  end

  def destroy
  end

  private
    # Strong Parameter設定
    def user_params
      params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
    end
end
