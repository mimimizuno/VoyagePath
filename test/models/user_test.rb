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

  # calculate_experience_on_loginで経験値が計算されるか
  test "should calculate experience on login" do
    @user.tasks.create(title: "Task", due_date: Date.yesterday, completed: true)
    @user.calculate_experience_on_login
    # 昨日分の経験値が計算されていることを確認
    assert @user.experience_points > 0, "Experience points should be greater than 0"
  end
  
  # last_experience_update_atが更新されるか
  test "should update last_experience_update_at after experience calculation" do
    @user.tasks.create(title: "Task", due_date: Date.yesterday, completed: true)
    @user.calculate_experience_on_login
    # 日付が今日に更新されていることを確認
    assert_equal Date.today, @user.last_experience_update_at, "Last experience update date should be today"
  end
  
  # 月末の月曜日で日、週、月の経験値加算ができているのか
  test "should calculate both daily, weekly, monthly experience on Monday" do
    # 例として2024/10/2(月)を取得
    monday = Date.new(2024, 10, 2).beginning_of_week
    7.times do |n|
      @user.tasks.create(title: "Task#{n}", due_date: monday - 3 + n, completed: true)
    end
    # 日曜日時点での経験値を保存
    initial_experience_points = @user.experience_points
    # 最後の計算日を前日の日曜日に設定
    @user.update(last_experience_update_at: monday - 1.day)
    # 経験値計算
    @user.calculate_experience_on_login
    # debugger
    # 新しい経験値を取得
    new_experience_points = @user.experience_points
    # 日次の経験値が増えた分
    daily_experience = 0
    (monday..Date.today).each do |date|
      daily_experience += ((@user.tasks.where(due_date: date, completed: true).count).to_f / (@user.tasks.where(due_date: date).count).to_f * 3).round + @user.tasks.where(due_date: date, completed: true).count
    end
    # 週次の経験値が増えた分
    weekly_experience = (((@user.tasks.where(due_date: monday.beginning_of_week..monday.end_of_week, completed: true).count).to_f / (@user.tasks.where(due_date: monday.beginning_of_week..monday.end_of_week).count).to_f) * 10).round
    # 月次の経験値が増えた分
    monthly_experience = (((@user.tasks.where(due_date: monday.beginning_of_month..monday.end_of_month, completed: true).count).to_f / (@user.tasks.where(due_date: monday.beginning_of_week..monday.end_of_week).count).to_f) * 30).round
    # 経験値が日次、週次、月次の合計分増えたことを確認
    assert_equal initial_experience_points + daily_experience + weekly_experience + monthly_experience, new_experience_points, "Experience points should include both daily and weekly bonuses"
  end

  # レベルアップが正しく動作するかどうか
  test "should level up when eperience reaches threshold" do
    @user.update(level: 1, experience_points: 95)

    # 経験値を追加(次のレベルまで5、10与えて5持ち越す)
    @user.add_experience(10)

    assert_equal 2, @user.level, "User should level up to level 2"
    assert_equal 5, @user.experience_points, "Remaining experience points should be 5"
  end

end
