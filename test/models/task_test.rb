require "test_helper"

class TaskTest < ActiveSupport::TestCase

  setup do
    @user = users(:michael)
    # 繰り返しなしのタスク
    @task = Task.new(
      title: "Task Title",
      due_date: Date.today,
      user: @user
    )
  end
  
  # 有効な情報でタスク生成（繰り返しなし）
  test "should be valid with title and due_date" do
    assert @task.valid?
  end

  # タイトル無しでタスク生成
  test "should be invalid without title" do
    @task.title = ""
    assert_not @task.valid?
  end

  # due_date無しでタスク生成
  test "should be invalid without due_date" do
    @task.due_date = ""
    assert_not @task.valid?
  end
  
  # copletedのデフォルトがfalseかどうか
  test "completed sholud default to false" do
    assert_equal false, @task.completed
  end

  # 週の繰り返しタスクが自動的に生成されることをテスト
  test "should not create duplicate weekly tasks" do
    # 繰り返し設定のあるタスクを作成（週）
    @task_weekly = Task.create!(
      title: "Weekly Task",
      due_date: Date.today - 1 .week,
      repetition: { type: 'weekly', days: ["Monday", "Wednesday", "Friday"] }.to_json,
      user: @user
    )

    # 月、水、金の3つが生成
    assert_difference 'Task.count', 3 do
      Task.generate_tasks_for_user(@user)
    end

    # 生成元の繰り返し設定が解除されたことを確認
    previous_week_range = (Date.today.beginning_of_week - 1.week)..(Date.today.end_of_week - 1.week)
    previous_week_tasks = @user.tasks.where(due_date: previous_week_range)
    previous_week_tasks.each do |task|
      assert_nil task.repetition, "Task repetition should be nil for previous week's tasks"
    end

    # 生成後の繰り返し設定が存在することを確認
    this_week_range = (Date.today.beginning_of_week)..(Date.today.end_of_week)
    this_week_tasks = @user.tasks.where(due_date: this_week_range)
    this_week_tasks.each do |task|
      assert_not_nil task.repetition, "Task repetition should be not nil for this week's tasks"
    end
  end

  # 月の繰り返しタスクが自動的に生成されることをテスト
  test "should not create duplicate monthly tasks" do
    # 繰り返し設定のあるタスクを作成（月）
    @task_monthly = Task.create!(
      title: "Monthly Task",
      due_date: Date.today - 1 .month,
      repetition: { type: 'monthly', days: ["1", "5", "15"] }.to_json,
      user: @user
    )

    # 1, 5, 15の3つ
    assert_difference 'Task.count', 3 do
      Task.generate_tasks_for_user(@user)
    end

    # 生成元の繰り返し設定が解除されたことを確認
    previous_month_range = (Date.today.beginning_of_month - 1.month)..(Date.today.end_of_month - 1.month)
    previous_month_tasks = @user.tasks.where(due_date: previous_month_range)
    previous_month_tasks.each do |task|
      assert_nil task.repetition, "Task repetition should be nil for previous month's tasks"
    end

    # 生成後の繰り返し設定が存在することを確認
    this_month_range = (Date.today.beginning_of_month)..(Date.today.end_of_month)
    this_month_tasks = @user.tasks.where(due_date: this_month_range)
    this_month_tasks.each do |task|
      assert_not_nil task.repetition, "Task repetition should be not nil for this month's tasks"
    end
  end

  # すでに一度生成された状態で２度目の生成でうまく動作するかをテスト
  test "should generate tasks correctly on second run" do
    # 同じ繰り返し設定のあるタスクを3つ作成（週）
    @task_weekly1 = Task.create!(
      title: "Weekly Task",
      due_date: Date.today - 1 .week - 1 .day,
      repetition: { type: 'weekly', days: ["Monday", "Wednesday", "Friday"] }.to_json,
      user: @user
    )
    @task_weekly2 = Task.create!(
      title: "Weekly Task",
      due_date: Date.today - 1 .week - 2 .day,
      repetition: { type: 'weekly', days: ["Monday", "Wednesday", "Friday"] }.to_json,
      user: @user
    )
    @task_weekly3 = Task.create!(
      title: "Weekly Task",
      due_date: Date.today - 1 .week - 3 .day,
      repetition: { type: 'weekly', days: ["Monday", "Wednesday", "Friday"] }.to_json,
      user: @user
    )

    # 生成されるタスクは3つ
    assert_difference 'Task.count', 3 do
      Task.generate_tasks_for_user(@user)
    end

    # 生成元の繰り返し設定が解除されたことを確認
    previous_week_range = (Date.today.beginning_of_week - 1.week)..(Date.today.end_of_week - 1.week)
    previous_week_tasks = @user.tasks.where(due_date: previous_week_range)
    previous_week_tasks.each do |task|
      assert_nil task.repetition, "Task repetition should be nil for previous week's tasks"
    end

    # 生成後の繰り返し設定が存在することを確認
    this_week_range = (Date.today.beginning_of_week)..(Date.today.end_of_week)
    this_week_tasks = @user.tasks.where(due_date: this_week_range)
    this_week_tasks.each do |task|
      assert_not_nil task.repetition, "Task repetition should be not nil for this week's tasks"
    end
  end

  # 週と月の繰り返しタスクが自動的に生成されることをテスト
  test "should not create duplicate weekly and monthly tasks" do
    # 繰り返し設定のあるタスクを作成（週）
    @task_weekly = Task.create!(
      title: "Weekly Task",
      due_date: Date.today - 1 .month,
      repetition: { type: 'weekly', days: ["Monday", "Wednesday", "Friday"] }.to_json,
      user: @user
    )

    # 繰り返し設定のあるタスクを作成（月）
    @task_monthly = Task.create!(
      title: "Monthly Task",
      due_date: Date.today - 1 .month,
      repetition: { type: 'monthly', days: ["1", "5", "15"] }.to_json,
      user: @user
    )

    # 1, 5, 15の3つ
    assert_difference 'Task.count', 6 do
      Task.generate_tasks_for_user(@user)
    end

    # 生成元の繰り返し設定が全て解除されたことを確認
    previous_month_range = (Date.today.beginning_of_month - 1.month)..(Date.today.end_of_month - 1.month)
    previous_month_tasks = @user.tasks.where(due_date: previous_month_range)
    previous_month_tasks.each do |task|
      assert_nil task.repetition, "Task repetition should be nil for previous month's tasks"
    end

    # 生成後の繰り返し設定が全て存在することを確認
    this_month_range = (Date.today.beginning_of_month)..(Date.today.end_of_month)
    this_month_tasks = @user.tasks.where(due_date: this_month_range)
    this_month_tasks.each do |task|
      assert_not_nil task.repetition, "Task repetition should be not nil for this month's tasks"
    end
  end
end
