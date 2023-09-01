class ServiceReviewsController < ApplicationController
  before_action :require_login
  before_action :set_review_params, only: [:new, :create]
  before_action :find_order, only: [:new, :create]

  def new
    if already_reviewed?(@order.id)
      flash[:notice] = 'Este servicio ya ha sido evaluado.'
      redirect_to("/users/#{@current_user.id}/orders")
    else
      @review = ServiceReview.new
      @review.service_id = @service_id
      @review.user_id = @current_user.id if @current_user
      @review.order_id = @order.id
    end
  end

  def create
    if already_reviewed?(@order_id)
      flash[:error] = 'Este servicio ya ha sido evaluado.'
      redirect_to("/users/#{@current_user.id}/orders") and return
    end

    @review = ServiceReview.new(review_params)

    if @review.save
      flash[:notice] = 'La evaluación ha sido registrada.'
      redirect_to("/users/#{@current_user.id}/orders")
    else
      render 'new'
    end
  end

  private

  def require_login
    unless @current_user
      flash[:error] = 'Se requiere iniciar sesión.'
      redirect_to login_path
    end
  end

  def review_params
    params.require(:service_review).permit(:user_id, :service_id, :rating, :comment, :order_id)  # :order_idを追加
  end

  def set_review_params
    @service_id = params[:service_id]
  end

  def already_reviewed?(order_id)
    ServiceReview.where(order_id: order_id).exists?
  end

  def find_order
    @order = Order.find_by(service_id: @service_id, buyer_id: @current_user.id)
  end
end
