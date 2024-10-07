require "test_helper"

class UserAvatarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @user_avatar = user_avatars(:one)
    @avatar = avatars(:dog)
    @other_user = users(:john)
  end

  # indexアクション(ログイン必須,他ユーザーでは入れない)
  test "should get index with login information" do
    # ログインせずにaction
    get user_user_avatars_path(@user)
    assert_not flash[:danger].nil?

    # 他のユーザー
    log_in_as(@other_user)
    get user_user_avatars_path(@user)
    assert_response :see_other

    # 正しいユーザー
    log_in_as(@user)
    get user_user_avatars_path(@user)
    assert_response :success

  end

  # createアクション(ログイン必須,他ユーザーでは入れない)
  test "should get create with login information" do
    # ログインせずにaction
    get user_user_avatars_path(@user), params: { avatar_id: @avatar.id }
    assert_not flash[:danger].nil?

    # 他のユーザー
    log_in_as(@other_user)
    get user_user_avatars_path(@user), params: { avatar_id: @avatar.id }
    assert_response :see_other

    # 正しいユーザー
    log_in_as(@user)
    get user_user_avatars_path(@user), params: { avatar_id: @avatar.id }
    assert_response :success

  end

  # updateアクション(ログイン必須,他ユーザーでは入れない)
  test "should update active avatar via radio button with login information" do
    # ログインせずにaction
    put user_user_avatar_path(@user, @user_avatar), params: { avatar_id: @avatar.id }
    assert_not flash[:danger].nil?

    # 他のユーザー
    log_in_as(@other_user)
    put user_user_avatar_path(@user, @user_avatar), params: { avatar_id: @avatar.id }
    assert_response :see_other

    # 正しいユーザー
    log_in_as(@user)
    put user_user_avatar_path(@user, @user_avatar), params: { avatar_id: @avatar.id }
    assert @user.user_avatars.find_by(avatar_id: @avatar.id).is_active
    assert_redirected_to user_path(@user)
  end

  # アバターが選択されなかった場合, 保持してるアバターのis_activeが全てfalseになる
  test "should set all avatars is_active to false when no avatar is selected" do
    # 正しいユーザー
    log_in_as(@user)
    put user_user_avatar_path(@user, @user_avatar), params: { avatar_id: nil }
    # アクティブなアバターが存在しないことを確認
    assert_not @user.user_avatars.find_by(avatar_id: @avatar.id).is_active
    assert_redirected_to user_path(@user)
  end

end
