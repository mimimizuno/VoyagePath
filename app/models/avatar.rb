class Avatar < ApplicationRecord
    has_many :user_avatars
    has_many :users, through: :user_avatars

    validates :avatar_name, presence: true
    validates :image_url,   presence: true
    validates :required_level, numericality: { greater_than_or_equal_to: 0 }
end
