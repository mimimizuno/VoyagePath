require "test_helper"

class UserAvatarTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @avatar = avatars(:cat)
    @user_avatar = UserAvatar.new(user: @user, avatar: @avatar)
  end

  # 有効かどうか確認
  test "should be valid" do
    assert @user_avatar.valid?
  end

  # userが存在しない
  test "user should be present" do
    @user_avatar.user = nil
    assert_not @user_avatar.valid?
  end

  # avatarが存在しない
  test "avatar should be present" do
    @user_avatar.avatar = nil 
    assert_not @user_avatar.valid?
  end

  # ユーザーとアバターの関連が一意であることを確認
  test "should not allow duplicate user_avatar pairs" do
    duplicate_user_avatar = @user_avatar.dup
    @user_avatar.save
    assert_not duplicate_user_avatar.valid?
  end

end
