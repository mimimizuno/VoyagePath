class UserAvatarsController < ApplicationController
  before_action :set_user

  def index
    @avatars = @user.avatars
  end

  def create
  end

  def update
  end
end

def set_user
  @user = User.find(params[:user_id])
end
