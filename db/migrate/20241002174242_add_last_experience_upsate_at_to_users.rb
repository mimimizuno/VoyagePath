class AddLastExperienceUpsateAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_experience_update_at, :date
  end
end
