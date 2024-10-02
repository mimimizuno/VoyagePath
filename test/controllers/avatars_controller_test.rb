require "test_helper"

class AvatarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @avatar = avatars(:dog)
  end

  # indexアクション
  test "should get index" do
    get avatars_path
    assert_response :success
  end

  # showアクション
  test "should get show" do
    get avatar_path(@avatar)
    assert_response :success
  end
end
