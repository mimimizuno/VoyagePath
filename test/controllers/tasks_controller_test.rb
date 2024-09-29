require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:michael)
    @task = tasks(:one)
  end

  test "should get index" do
    get user_tasks_url(@user)
    assert_response :success
  end

  test "should get new" do
    get new_user_task_url(@user)
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post user_tasks_url(@user), params: { task: { title: 'New Task', due_date: Date.today } }
    end
    assert_redirected_to user_tasks_url(@user)
  end

  test "should show task" do
    get user_task_url(@user, @task)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_task_url(@user, @task)
    assert_response :success
  end

  test "should update task" do
    put user_task_url(@user, @task), params: { task: { title: 'Updated Task' } }
    assert_redirected_to user_task_url(@user, @task)
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete user_task_url(@user, @task)
    end
    assert_redirected_to user_tasks_url(@user)
  end

end
