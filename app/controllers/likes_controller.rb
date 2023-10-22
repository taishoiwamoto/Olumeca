class LikesController < ApplicationController
  before_action :authenticate_user

  def create
    service = Service.find(params[:service_id])

    unless service
      redirect_to root_path, alert: 'Service not found.'
      return
    end

    @like = current_user.likes.create(service_id: service.id)

    redirect_to service_path(service.id)
  end

  def destroy
    @like = Like.find_by!(user_id: current_user.id, service_id: params[:service_id])

    @like.destroy
    redirect_to service_path(params[:service_id])
  end
end
