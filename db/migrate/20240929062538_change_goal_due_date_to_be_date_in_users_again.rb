class ChangeGoalDueDateToBeDateInUsersAgain < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :goal_due_date, 'date USING goal_due_date::date'
  end
end