class LikesController < ApplicationController
  before_action :authenticate_user


  def create
    @like = Like.new(user_id: @current_user.id, service_id: params[:service_id])
    @like.save
    redirect_to("/services/#{params[:service_id]}")
  end

  def destroy
    @like = Like.find_by(user_id: @current_user.id, service_id: params[:service_id])
    @like.destroy
    redirect_to("/services/#{params[:service_id]}")
  end

end
