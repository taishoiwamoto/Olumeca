class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_service
  before_action :set_review, only: [:edit, :update]
  before_action :authorized_user, only: [:edit, :update]

  def new
    @review = @service.reviews.build(user: current_user)
  end

  def create
    @review = @service.reviews.build review_params
    @review.user = current_user

    if @review.save
      redirect_to orders_user_path(current_user), notice: 'La evaluación ha sido creada.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to orders_user_path(current_user), notice: 'La evaluación ha sido actualizada.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def require_login
    return if current_user

    redirect_to new_user_session_path, notice: 'Se requiere iniciar sesión'
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorized_user
    return if @review.user.eql?(current_user)

    redirect_to root_path, notice: 'No tiene permiso para editar esta evaluación.'
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def set_service
    @service = Service.find(params[:service_id])
  end
end
