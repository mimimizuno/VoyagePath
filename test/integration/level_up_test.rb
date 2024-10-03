require "test_helper"

class LevelUpTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # タスクを生成し、ログインすることで経験値を取得し、レベルアップ
  test "create new tasks and log in should get experience and level up" do
    @user.update(last_experience_update_at: Date.yesterday - 1.day)
    @user.update(experience_points: 90)
    @user.tasks.create(title: "Task", due_date: Date.yesterday, completed: true)
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert is_logged_in?
    @user.reload
    # レベルの上昇
    assert_equal 2, @user.level
    # レベルが上昇したことによるflashの表示
    assert_equal "Congratulations! You have leveled up to level 2!!", flash[:notice]
    # 経験値の引き継ぎの確認
    assert @user.experience_points > 0
  end

end
