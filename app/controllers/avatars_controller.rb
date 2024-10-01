class AvatarsController < ApplicationController
  def index
    @avatars = Avatar.all
  end

  def show
    @avatar = Avatar.find(params[:id])
  end
end
