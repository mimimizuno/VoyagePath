class UserAvatarsController < ApplicationController
  before_action :set_user

  def index
    @avatars = @user.avatars
  end

  # 新しいアバターを取得する
  def create
    # 取得可能なアバターを検索
    unlockable_avatars = Avatar.where("required_level <= ?", @user.level).where.not(id: @user.avatar_ids)
    
    if unlockable_avatars.any?
      unlockable_avatars.each do |avatar|
        @user.avatars << avatar
      end
      flash[:success] = "#{unlockable_avatars.map(&:avatar_name).join(', ')} を取得しました！"
    end
    redirect_to user_user_avatars_path(@user)
  end

  # アクティブなアバターを更新する
  def update
    user_avatar = @user.user_avatars.find_by(avatar_id: params[:avatar_id])  # チェックボックスで選択されたアバターを取得
    if user_avatar.update(is_active: true)
      # 他のアバターを非アクティブにする
      @user.user_avatars.where.not(id: user_avatar.id).update_all(is_active: false)
      flash[:success] = "アクティブなアバターを#{user_avatar.avatar.avatar_name}に更新しました！"
    else
      flash[:danger] = "アクティブなアバターの更新に失敗しました。"
    end
    redirect_to user_path(@user)
  end

  private

  # before actions

  def set_user
    @user = User.find(params[:user_id])
  end

end
