require "test_helper"

class UserAvatarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @user_avatar = user_avatars(:one)
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
  test "should update active avatar via radio button" do
    put user_user_avatar_path(@user, @user_avatar), params: { avatar_id: @avatar.id }
    assert @user.user_avatars.find_by(avatar_id: @avatar.id).is_active
    assert_redirected_to user_path(@user)
  end
end
