class AddDefaultValuesToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :level, 1
    change_column_default :users, :experience_points, 0
  end
end