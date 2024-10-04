require "test_helper"

class AvatarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @avatar = avatars(:dog)
  end

  # indexアクション(ログイン必須)
  test "should get index with login information" do
    # 非ログイン
    get avatars_path
    assert_not flash[:danger].nil?

    # ログイン
    log_in_as(@user)
    get avatars_path
    assert_response :success
  end

  # showアクション(ログイン必須)
  test "should get show" do
    # 非ログイン
    get avatar_path(@avatar)
    assert_not flash[:danger].nil?

    # ログイン
    log_in_as(@user)
    get avatar_path(@avatar)
    assert_response :success
  end
end
