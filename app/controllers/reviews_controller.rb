class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_review_params, only: [:new]
  before_action :find_order, only: [:new]
  before_action :set_review, only: [:edit, :update]
  before_action :authorized_user, only: [:edit, :update]

  def new
    existing_reviews = Review.where(user_id: current_user.id, service_id: service.id)

    if existing_reviews.any?
      redirect_to edit_review_path(existing_reviews.first)
    else
      @review = Review.new
      @review.user_id = current_user.id if current_user
      @review.order_id = @order.id
    end
  end

  def create
    @review = Review.new(review_params)
    order = Order.find_by!(buyer_id: current_user.id, id: @review.order_id)
    @review.user_id = order.buyer_id
    @errores = ''

    existing_reviews = Review.where(user_id: current_user.id, service_id: order.service.id)
    if existing_reviews.any?
      redirect_to edit_review_path(existing_reviews.first)
      return
    end

    if @review.save
      flash[:notice] = 'La evaluación ha sido registrada.'
      redirect_to orders_user_path(current_user)
    else
      @errores = @review.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash[:notice] = 'La evaluación ha sido actualizada.'
      redirect_to orders_user_path(current_user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def require_login
    unless current_user
      flash[:error] = 'Se requiere iniciar sesión.'
      redirect_to new_user_session_path
    end
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorized_user
    return if @review.user_id == current_user.id

    flash[:error] = 'No tiene permiso para editar esta evaluación.'
    redirect_to root_path
  end

  def review_params
    params.require(:review).permit(:user_id, :rating, :comment, :order_id, :service_id)
  end

  def find_order
    @order_id = params[:order_id]
    @order = Order.find_by!(id: @order_id, buyer_id: current_user.id)
  end
end
