require "test_helper"

class AvatarTest < ActiveSupport::TestCase
  def setup
    @avatar = avatars(:dog)
  end

  # 有効かどうかのテスト
  test "should be valid" do
    assert @avatar.valid?
  end

  # avatar_nameが存在しない場合
  test "avatar_name should be present" do
    @avatar.avatar_name = " "
    assert_not @avatar.valid?
  end

  # image_nameが存在しない場合
  test "image_name should be present" do
    @avatar.image_name = " "
    assert_not @avatar.valid?
  end

  # required_levelが0以上であること
  test "required_level should be greater than or equal to 0" do
    @avatar.required_level = -1
    assert_not @avatar.valid?
  end
  
end

