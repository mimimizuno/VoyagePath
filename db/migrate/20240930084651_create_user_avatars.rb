class CreateUserAvatars < ActiveRecord::Migration[7.0]
  def change
    create_table :user_avatars do |t|
      t.references :user, null: false, foreign_key: true
      t.references :avatar, null: false, foreign_key: true
      t.boolean :is_active, default: false

      t.timestamps
    end
  end
end
