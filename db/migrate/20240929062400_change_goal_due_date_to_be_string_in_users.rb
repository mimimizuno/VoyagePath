class ChangeGoalDueDateToBeStringInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :goal_due_date, :string
  end
end
