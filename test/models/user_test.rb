require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  # テストケースのセットアップ
  def setup
    @user = users(:sam)
  end
  
  # セットアップユーザーが有効かどうか
  test "should be valid" do
    assert @user.valid?
  end

  # ユーザーの名前が存在しないとエラー
  test "name should be present" do
    @user.user_name = "   "
    assert_not @user.valid?
  end

  # ユーザーの名前が長すぎるとエラー
  test "name should not be too long" do
    @user.user_name = "a" * 51
    assert_not @user.valid?
  end

  # emailが長すぎるとエラー
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # 有効じゃないemailだとエラー
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # emailの一意性チェック
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # パスワードが空だとエラー
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # パスワードが5文字以下だとエラー
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # levelの初期値チェック
  test "level should default to 1" do
    assert_equal 1, @user.level
  end

  # experience_pointsの初期値チェック
  test "experiece_points should default to 0" do
    assert_equal 0, @user.experience_points
  end

  # goalが256文字以上だとエラー
  test "goal should not be too long" do
    @user.goal = "a" * 256
    assert_not @user.valid?
  end


  # 記憶ダイジェストが無効の場合のテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

  # 毎日の経験値計算のテスト
  test "should update daily experience with completed tasks" do
    @user.tasks.create(title: "Task 1", due_date: Date.today, completed: true)
    @user.tasks.create(title: "Task 2", due_date: Date.today, completed: false)
  
    # タスク1は完了、タスク2は未完了、達成率は50%で3 * 0.5 = 1.5 → 2ポイント+1個のタスク消化で1ポイントの合計3ポイント
    assert_difference '@user.experience_points', 3 do
      @user.update_daily_experience
    end
  end

  # 週の経験値計算のテスト
  test "should update weekly experience with multiple tasks" do
    @user.tasks.create(title: "Weekly Task 1", due_date: Date.today.beginning_of_week, completed: true)
    @user.tasks.create(title: "Weekly Task 2", due_date: Date.today.end_of_week, completed: true)
  
    # 2つのタスクが完了しているので、達成率は100%で10 * 1 = 10、経験値は10ポイント
    assert_difference '@user.experience_points', 10 do
      @user.update_weekly_experience
    end
  end
  
  # 月の経験値計算のテスト
  test "should update monthly experience with repeating tasks" do
    @user.tasks.create(title: "Monthly Task 1", due_date: Date.today.beginning_of_month, completed: true)
    @user.tasks.create(title: "Monthly Task 2", due_date: Date.today.end_of_month, completed: false)
  
    # 1つのタスクが完了しているので達成率は50%、経験値は15ポイント (30ポイントの50%)
    assert_difference '@user.experience_points', 15 do
      @user.update_monthly_experience
    end
  end

end
