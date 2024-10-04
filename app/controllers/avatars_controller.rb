class AvatarsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @avatars = Avatar.all
  end

  def show
    @avatar = Avatar.find(params[:id])
  end
end
