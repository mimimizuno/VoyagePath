class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      # ログイン時のチェックボックスで三項演算
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      # ログイン前の経験値を保存
      initial_experience_points = user.experience_points
      # ログイン時に経験値を計算する
      user.calculate_experience_on_login
      # debugger
      user.save
      if user.experience_points > initial_experience_points
        flash.now[:notice] = "Welcome back! Your experience points have been updated."
      end
      redirect_to forwarding_url || user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

end
