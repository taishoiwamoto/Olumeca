class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_review_params, only: [:new, :create]
  before_action :find_order, only: [:new, :create]

  def new
    plan = Plan.find(@plan_id)
    existing_reviews = Review.where(user_id: current_user.id, plan: Plan.where(service: plan.service))

    if existing_reviews.any?
      redirect_to edit_review_path(existing_reviews.first)
    else
      @review = Review.new
      @review.plan_id = @plan_id
      @review.user_id = current_user.id if current_user
      @review.order_id = @order.id
    end
  end


  def create
    @review = Review.new(review_params)

    if @review.save
      flash[:notice] = 'La evaluación ha sido registrada.'
      redirect_to orders_user_path(current_user)
    else
      render 'new'
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])

    # このレビューが現在のユーザーに属していることを確認（セキュリティのため）
    unless @review.user_id == current_user.id
      flash[:error] = 'No tiene permiso para editar esta evaluación.'
      redirect_to root_path and return
    end

    if @review.update(review_params)
      flash[:notice] = 'La evaluación ha sido actualizada.'
      redirect_to orders_user_path(current_user)
    else
      render 'edit'
    end
  end

  private

  def require_login
    unless current_user
      flash[:error] = 'Se requiere iniciar sesión.'
      redirect_to new_user_session_path
    end
  end

  def review_params
    params.require(:review).permit(:user_id, :plan_id, :rating, :comment, :order_id)  # <-- 変更した部分
  end

  def set_review_params
    @plan_id = params[:plan_id]  # <-- 変更した部分
  end

  def find_order
    @order_id = params[:order_id]
    @order = Order.find_by(id: @order_id, buyer_id: current_user.id)
  end
end
