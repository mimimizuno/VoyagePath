require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:michael)
    @task = tasks(:one)

    # 今週のタスク
    @this_week_task = Task.create!(
      title: "This Week Task",
      due_date: Date.today.beginning_of_week,
      user: @user
    )
    
    # 前の週のタスク
    @previous_week_task = Task.create!(
      title: "Previous Week Task",
      due_date: Date.today.beginning_of_week - 1.week,
      user: @user
    )

    # 次の週のタスク
    @next_week_task = Task.create!(
      title: "Next Week Task",
      due_date: Date.today.beginning_of_week + 1.week,
      user: @user
    )
  end

  # index アクション
  test "should get index" do
    get user_tasks_url(@user)
    assert_response :success
  end

  # new アクション
  test "should get new" do
    get new_user_task_url(@user)
    assert_response :success
  end

  # create アクション
  test "should create task" do
    assert_difference('Task.count') do
      post user_tasks_url(@user), params: { task: { title: 'New Task', due_date: Date.today } }
    end
    assert_redirected_to user_tasks_url(@user)
  end

  # show アクション
  test "should show task" do
    get user_task_url(@user, @task)
    assert_response :success
  end

  # editアクション
  test "should get edit" do
    get edit_user_task_url(@user, @task)
    assert_response :success
  end

  # update アクション
  test "should update task" do
    put user_task_url(@user, @task), params: { task: { title: 'Updated Task' } }
    assert_redirected_to user_task_url(@user, @task)
  end

  # destroy アクション
  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete user_task_url(@user, @task)
    end
    assert_redirected_to user_tasks_url(@user)
  end

  # 今週の表を表示するテスト
  test "should show this week's tasks" do
    get week_user_tasks_path(@user, start_date: Date.today.beginning_of_week)
    assert_response :success

    # 今週のタスクが表示されているか確認
    assert_select 'li', text: /This Week Task/
    # 前の週や次の週のタスクは表示されないことを確認
    assert_select 'li', text: /Previous Week Task/, count: 0
    assert_select 'li', text: /Next Week Task/, count: 0
  end

  # 前の週の表を表示するテスト
  test "should show previous week's tasks" do
    get week_user_tasks_path(@user, start_date: Date.today.beginning_of_week - 1.week)
    assert_response :success

    # 前の週のタスクが表示されているか確認
    assert_select 'li', text: /Previous Week Task/
    # 今週や次の週のタスクは表示されないことを確認
    assert_select 'li', text: /This Week Task/, count: 0
    assert_select 'li', text: /Next Week Task/, count: 0
  end

  # 前の週の表を表示するテスト
  test "should show next week's tasks" do
    get week_user_tasks_path(@user, start_date: Date.today.beginning_of_week + 1.week)
    assert_response :success

    # 今週のタスクが表示されているか確認
    assert_select 'li', text: /Next Week Task/
    # 前の週や今週のタスクは表示されないことを確認
    assert_select 'li', text: /This Week Task/, count: 0
    assert_select 'li', text: /Previous Week Task/, count: 0
  end
end
