require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should get edit" do
    user = users(:michael)
    get edit_user_path(user)
    assert_response :success
  end
end
