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
      # ログイン前の経験値とレベルを保存
      initial_experience_points = user.experience_points
      initial_level = user.level
      # ログイン時に経験値を計算する(レベルアップ処理を含む)
      user.calculate_experience_on_login
      user.save
      if user.experience_points > initial_experience_points
        flash.now[:notice] = "Welcome back! Your experience points have been updated."
      end
      if user.level > initial_level
        flash.now[:notice] = "Congratulations! You have leveled up to level #{user.level}!!"
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
