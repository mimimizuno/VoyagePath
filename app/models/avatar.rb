class Avatar < ApplicationRecord
    has_many :user_avatars
    has_many :users, through: :user_avatars

    validates :avatar_name, presence: true
    validates :image_name,   presence: true
    validates :required_level, numericality: { greater_than_or_equal_to: 0 }

    # アバターの画像pathを生成
    def image_path
      ActionController::Base.helpers.asset_path("avatars/#{self.image_name}")
    end

end
