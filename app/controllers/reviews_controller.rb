class ReviewsController < ApplicationController
  before_action :authenticate_user
  before_action :set_service
  before_action :set_review, only: [:new, :create, :edit, :update]

  def new
    if @service.reviews.where(user: current_user).exists?
      redirect_to service_path(@service), notice: 'Ya has evaluado este servicio.'
    else
      @review = @service.reviews.build(user: current_user)
    end
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

  def set_service
    @service = Service.includes(:reviews).find(params[:service_id])

    check_review_possibility if %w[new create].include?(action_name)
  end

  def set_review
    @review = Review.find_by(id: params[:id]) || @service.reviews.where(user: current_user).first

    authorized_user if %w[edit update].include?(action_name)
  end

  def authorized_user
    return if @review.user_id == current_user.id
    redirect_to root_path, notice: 'No tiene permiso para editar esta evaluación.'
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def check_review_possibility
    purchased = Order.exists?(buyer: current_user, service: @service)

    reviewed = Order.service_reviewed_by_user?(current_user.id, @service.id)

    unless purchased && !reviewed
      redirect_to orders_user_path(current_user), notice: 'No puedes evaluar este servicio.'
    end
  end
end
