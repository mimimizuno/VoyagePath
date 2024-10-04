require "test_helper"

class RecurringTasksTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @task_weekly = Task.create!(
      title: "Weekly Task",
      due_date: Date.today - 1 .week,
      repetition: { type: 'weekly', days: ["Monday", "Wednesday", "Friday"] }.to_json,
      user: @user
    )
  end

  # applicationコントローラによるタスクの自動生成
  test "should generate tasks automatically" do
    @user.update(last_task_update_at: Date.yesterday - 1)
    log_in_as @user
    # get user_path(@user)でタスクが自動生成される
    assert_difference 'Task.count', 3 do
      get user_path(@user)
    end
    @user.reload
    # タスクが生成されたことによるflashの生成
    assert_not flash.empty?
    # last_task_update_atが更新されるかどうか
    assert_equal Date.today, @user.last_task_update_at
  end

end
