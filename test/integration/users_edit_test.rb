require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # 無効な情報でのedit
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    put user_path(@user), params: { user: { user_name: "  ",
                                            goal: "test",
                                            goal_due_date: "invalid" } }
    assert_template 'users/edit'
  end

  # 有効な情報でのedit、フレンドリーフォワーディングのテストも含む
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    put user_path(@user), params: { user: { user_name: "test",
                                            goal: "test",
                                            goal_due_date: Date.today - 1 } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "test", @user.user_name
    assert_equal "test", @user.goal
    assert_equal Date.today - 1, @user.goal_due_date 
  end

end
