class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :email
      t.string :goal
      t.time :goal_due_date
      t.integer :level
      t.integer :experience_points

      t.timestamps
    end
  end
end
