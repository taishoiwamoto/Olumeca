class ServicesController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @services = Service.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @service = Service.find_by(id: params[:id])
    @user = @service.user
    @likes_count = Like.where(service_id: @service.id).count
    @reviews = @service.reviews.order(created_at: :desc).page(params[:page]).per(5)
    @total_reviews_count_for_user = Review.joins(:service).where(services: { user_id: @user.id }).count
  end


  def new
    @service = Service.new
    @service.plans.build
  end

  def create
    @service = current_user.services.build(service_params)

    if @service.save
      redirect_to service_path(@service), notice: "Has creado un servicio"
    else
      @service.plans.build unless @service.plans.present?
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @service = Service.find_by(id: params[:id])
  end

  def update
    @service = Service.find_by(id: params[:id])

    if @service.update(service_params)
      @service.update_plans(service_params[:plans_attributes].to_h)
      redirect_to service_path(@service), notice: 'Has editado un servicio'
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @service = Service.find_by(id: params[:id])
    @service.destroy
    flash[:notice] = "Has eliminado un servicio"
    redirect_to user_path(current_user)
  end

  def ensure_correct_user
    @service = Service.find_by(id: params[:id])
    unless @service.user == current_user
      flash[:notice] = "No tienes autorización"
      redirect_to service_path(@service)
    end
  end

  private

  def service_params
    params.require(:service).permit(:title, :detail, :category, :image,
                                    plans_attributes: [:title, :detail, :price, :delivery_method, :_destroy])
  end

  def service_form_params
    params.require(:service_form).permit(:title, :detail, :category, :image,
      plans_attributes: [:title, :detail, :price, :delivery_method, :_destroy])
  end
end
