module SessionsHelper
  # 渡されたユーザーでのログイン
  def log_in(user)
    session[:user_id] = user.id
    # セッションリプレイ対策
    session[:session_token] = user.session_token
  end

  # 永続的なセッションのためにユーザーをデータベースに記憶する
  def remember(user)
    user.remember # トークンを生成、データベースに保存
    cookies.permanent.encrypted[:user_id] = user.id # クッキーにユーザーIDを保存
    cookies.permanent[:remember_token] = user.remember_token # クッキーにトークンを保存
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    # session[:user_id]に値があればその値をuser_idに代入、その値がtrueだと実行
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      # ログインしたユーザーがセッションに保存されたトークンを持っているかどうか
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      # raise # テストがパスすればこの部分はテストされていない
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザーがcurrent_userであればtrue
  def current_user?(user)
    user && user == current_user
  end

  # ユーザーがログインしていればtrue, その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    reset_session
    # current_userの初期化
    @current_user = nil
  end

  # アクセスしようとしたURLを保存する
  def store_location
    # getリクエストに限定することでログインしているユーザーのみ転送先のURLを保存
    session[:forwarding_url] = request.original_url if request.get?
  end

end
