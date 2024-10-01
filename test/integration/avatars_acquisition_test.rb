require "test_helper"

class AvatarsAcquisitionTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)  # 初期状態ではレベル1
    @avatar_level1 = avatars(:dog)  # レベル1で獲得できるアバター
    @avatar_level2 = avatars(:cat)  # レベル2で獲得できるアバター
    @avatar_level50 = avatars(:lion) # レベル50
  end

  # レベル上昇によるアバター獲得のテスト
  test "user acquires new avatar when level increases" do
    log_in_as(@user) 
    assert @user.avatars.include?(@avatar_level1)
    assert_not @user.avatars.include?(@avatar_level2)
    assert_not @user.avatars.include?(@avatar_level50)

    # ユーザーのレベルを2にアップデートして、低レベルのアバターを獲得
    @user.update(level: 2)
    # レベル2で獲得したアバターを確認
    assert @user.avatars.include?(@avatar_level2)
    assert_not @user.avatars.include?(@avatar_level50)
    # ユーザーのレベルを50にアップデートして、高レベルのアバターを獲得
    @user.update(level: 50)
    # 高レベルアバターも獲得できているかを確認
    assert @user.avatars.include?(@avatar_level50)
  end
end
