class UserAvatarsController < ApplicationController
  before_action :logged_in_user
  before_action :set_user
  before_action :correct_user

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
    if params[:avatar_id].present?
      # アバターが選択された場合
      user_avatar = @user.user_avatars.find_by(avatar_id: params[:avatar_id])  # 選択されたアバターを取得
      if user_avatar.update(is_active: true)
        # 他のアバターを非アクティブにする
        @user.user_avatars.where.not(id: user_avatar.id).update_all(is_active: false)
        flash[:success] = "アバターを#{user_avatar.avatar.avatar_name}に更新しました！"
      else
        flash[:danger] = "アバターの更新に失敗しました。"
      end
    else
      # アバターが選択されなかった場合
      @user.user_avatars.update_all(is_active: false)
      flash[:success] = "アバターを解除しました。"
    end
    redirect_to user_path(@user)
  end

  private

  # before actions

  def set_user
    @user = User.find(params[:user_id])
  end

end
