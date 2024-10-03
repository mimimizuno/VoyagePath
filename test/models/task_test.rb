require "test_helper"

class TaskTest < ActiveSupport::TestCase

  setup do
    user = users(:michael)
    @task = Task.new(
      title: "Task Title",
      due_date: Date.today,
      user: user
    )
  end
  
  # 有効な情報でタスク生成（繰り返しなし）
  test "should be valid with title and due_date" do
    assert @task.valid?
    assert_not @task.repeat_today?
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

  #　週ごとの繰り返しタスク
  test "should repeat on specific weekdays" do
    # Date.today.srtftime("%A")は今日の曜日をフルネームで返す
    @task.repetition = { type: "weekly", days: [Date.today.strftime("%A")] }.to_json
    assert @task.repeat_today?, "Task should repeat today"
  end

  # 月毎の繰り返しタスク
  test "should repeat on specific day of the month" do
    # Date.today.dayで日付のみに変換
    @task.repetition = { type: "monthly", day: Date.today.day }.to_json
    assert @task.repeat_today?, "Task should repeat on the correct day of the month"
  end

  # 繰り返し設定されていない日
  test "should not repeat on non-repeating days" do
    @task.due_date = Date.yesterday
    @task.repetition = { type: "weekly", days: [Date.yesterday.strftime("%A")] }.to_json
    assert_not @task.repeat_today?, "Task should not repeat on non-repeating days"
  end

end
