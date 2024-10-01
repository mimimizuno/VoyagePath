require "test_helper"

class UserAvatarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @avatar = avatars(:dog)
  end

  # indexアクション
  test "should get index" do
    get user_user_avatars_path(@user)
    assert_response :success
  end

  # createアクション
  test "should get create" do
    get user_user_avatars_path(@user), params: { avatar_id: @avatar.id }
    assert_response :success
  end

  # updateアクション
  test "should get update" do
    put user_user_avatar_path(@user, @avatar), params: { is_active: true }
    assert_response :success
  end
end
