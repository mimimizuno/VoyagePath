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
  
  # 有効な情報でタスク生成
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

end
