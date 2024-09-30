require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    # ページ内に pagination があることを確認
    assert_select 'ul.pagination'
    # 表示されているユーザーのリンクを確認
    first_page_of_users = User.paginate(page: 1, per_page: 25)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.user_name
    end
  end

end
