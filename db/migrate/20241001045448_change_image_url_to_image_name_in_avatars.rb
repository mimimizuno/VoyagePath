class ChangeImageUrlToImageNameInAvatars < ActiveRecord::Migration[7.0]
  def change
    remove_column :avatars, :image_url, :string
    add_column :avatars, :image_name, :string, null: false
  end
end
