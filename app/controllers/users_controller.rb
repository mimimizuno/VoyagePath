class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    # pagination指定 1ページにつき25ユーザー
    @users = User.paginate(page: params[:page], per_page: 25 )
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
      # puts @user.errors.full_messages
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      # puts @user.errors.full_messages
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted!"
    redirect_to users_url, status: :see_other
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

  # before filters

  # ログイン済みユーザーかどうかを確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in!"
      redirect_to login_url, status: :see_other
    end
  end

  # 正しいユーザーかどうかを確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end

  # 管理者であるかどうか確認
  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end

end
