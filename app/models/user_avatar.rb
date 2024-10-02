class UserAvatar < ApplicationRecord
  belongs_to :user
  belongs_to :avatar

  validates_uniqueness_of :user_id, scope: :avatar_id
end
