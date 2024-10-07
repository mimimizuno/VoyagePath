class AvatarsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @avatars = Avatar.all
    @user = current_user
  end

  def show
    @avatar = Avatar.find(params[:id])
    @user = current_user
  end

end
