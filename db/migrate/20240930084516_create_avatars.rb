class CreateAvatars < ActiveRecord::Migration[7.0]
  def change
    create_table :avatars do |t|
      t.string :avatar_name, null: false
      t.string :image_url, null: false
      t.integer :required_level

      t.timestamps
    end
  end
end
