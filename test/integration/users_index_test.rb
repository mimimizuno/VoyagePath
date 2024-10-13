require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:john)
  end

  # 管理者としてログイン、paginationとdelete linkがあるか確認
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    # ページ内に pagination があることを確認
    assert_select 'ul.pagination'
    # 表示されているユーザーのリンクを確認
    first_page_of_users = User.paginate(page: 1, per_page: 15)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.user_name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: '削除'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end

  # 非管理者としてログイン、delete linkがないことを確認
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end
