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
    assert flash[:danger].nil?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    put user_path(@user), params: { user: { user_name: @user.user_name,
                                            email: @user.email } }
    assert flash[:danger].nil?
    assert_redirected_to root_url
  end

  # admin属性がweb経由で変更されないことを確認
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    put user_path(@other_user), params: {
                                  user: {
                                    admin: true
                                  }
    }
    @other_user.reload
    assert_not @other_user.admin?
  end

  # 非ログイン状態でのdestoryアクション
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  # 管理アカウント以外でのdestroyアクション
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

  # completion_ratesアクションのテスト(weekly)(ログイン必須)
  test "should get weekly_completion_rates" do
    get completion_rates_user_url(@user, period: 'weekly')
    assert_not flash.empty?
    log_in_as(@user)
    get completion_rates_user_url(@user, period: 'weekly')
    assert_response :success
    # JSONレスポンスのチェック
    json_response = JSON.parse(@response.body)
    # weeklyの大きさ7のjson
    assert_equal 7, json_response.size 
  end

  # completion_ratesアクションのテスト(monthly)
  test "should get monthly_completion_rates" do
    log_in_as(@user)
    # 現在の月の日数を取得
    days_in_month = Date.today.end_of_month.day
    get completion_rates_user_url(@user, period: 'monthly')
    assert_response :success
    # JSONレスポンスのチェック
    json_response = JSON.parse(@response.body)
    # monthの大きさのjson
    assert_equal days_in_month, json_response.size 
  end

  # completion_ratesアクションのテスト(yearly)
  test "should get yearly_completion_rates" do
    log_in_as(@user)
    # 現在の年の日数を取得
    days_in_year = Date.leap?(Date.today.year) ? 366 : 365
    get completion_rates_user_url(@user, period: 'yearly')
    assert_response :success
    # JSONレスポンスのチェック
    json_response = JSON.parse(@response.body)
    # monthの大きさのjson
    assert_equal days_in_year, json_response.size 
  end

end
