class FavoritesController < ApplicationController
  before_action :require_user_logged_in
#  before_action :correct_user
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like(@micropost)
    flash[:success] = 'お気に入りに登録しました。'
    redirect_to root_path
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like_off(@micropost)
    flash[:success] = 'お気に入りを解除しました。'
    redirect_to root_path
  end
end
