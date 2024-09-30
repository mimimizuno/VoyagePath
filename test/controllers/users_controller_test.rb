require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:john)
  end

  # newが動作するか
  test "should get new" do
    get signup_path
    assert_response :success
  end

  # 非ログイン状態でindex
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # showが動作するか
  test "should get show" do
    user = users(:michael)
    get user_path(user)
    assert_response :success
  end

  # editが動作するか
  test "should get edit" do
    user = users(:michael)
    log_in_as(user)
    get edit_user_path(user)
    assert_response :success
  end

  # loginしてない状態でeditに入るとエラー
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # loginしてない状態でupdateに入るとエラー
  test "should redirect update when not logged in" do
    put user_path(@user), params: { user: { user_name: @user.user_name,
                                            goal: @user.goal,
                                            goal_due_date: @user.goal_due_date } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    put user_path(@user), params: { user: { user_name: @user.user_name,
                                            email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

end
