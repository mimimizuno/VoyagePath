require "test_helper"

class LevelUpTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # last_experience_updateが今日ではない場合、いずれかのアクション実行で経験値を入手
  test "should calculation experience after any action if last_experience_update is yesterday" do
    @user.update(last_experience_update_at: Date.yesterday - 1)
    initial_experience_points = @user.experience_points
    @user.tasks.create(title: "Task", due_date: Date.yesterday, completed: true)
    log_in_as @user
    get user_path(@user)
    @user.reload
    # 昨日の経験値が計算される
    assert @user.experience_points > initial_experience_points
    # 経験値が変更されたことによるflashの表示
    assert_not flash.empty?
  end


  # タスクを生成し、アクションを実行することで経験値を取得し、レベルアップ
  test "create new tasks and log in should get experience and level up" do
    @user.update(last_experience_update_at: Date.yesterday - 1.day)
    @user.update(experience_points: 99)
    @user.tasks.create(title: "Task", due_date: Date.yesterday, completed: true)
    log_in_as @user
    get user_path(@user)
    @user.reload
    # レベルの上昇
    assert_equal 2, @user.level
    # レベルが上昇したことによるflashの表示
    assert_equal "おめでとうござます! レベルアップ! レベルが2になりました!", flash[:level_up]
    # 経験値の引き継ぎの確認
    assert @user.experience_points > 0
  end

end
