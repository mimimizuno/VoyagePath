require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  # 無効な情報でのログイン
  test "login with invalid information" do
    get login_path 
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_not is_logged_in?
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # 有効な情報でのログイン
  test "login with valid information followed by logout" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    delete logout_path
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not cookies[:remember_token].blank?
  end

  test "login without remembering" do
    # Cookieを保存してログイン
    log_in_as(@user, remember_me: '1')
    # Cookieが削除されていることを検証してからログイン
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end

  # ログインしたときに経験値が計算されるか
  test "should calculation experience on login" do
    @user.update(last_experience_update_at: Date.yesterday - 1.day)
    initial_experience_points = @user.experience_points
    @user.tasks.create(title: "Task", due_date: Date.yesterday, completed: true)
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert is_logged_in?
    @user.reload
    # 昨日の経験値が計算される
    assert @user.experience_points > initial_experience_points
    # 経験値が変更されたことによるflashの表示
    assert_not flash.empty?
  end
  
end
