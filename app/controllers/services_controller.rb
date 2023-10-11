class ServicesController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :set_service, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]

  def index
    @services = Service.active.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @service = Service.active.find_by(id: params[:id])
    if @service.nil?
      render file: "#{Rails.root}/public/404.html"
    else
      @user = @service.user
      @likes_count = Like.where(service_id: @service.id).count
      @reviews = @service.reviews.order(created_at: :desc).page(params[:page]).per(5)
    end
  end

  def new
    @service = Service.new
  end

  def create
    @service = current_user.services.build service_params

    if @service.save
      redirect_to service_path(@service), notice: "Has creado un servicio"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @service.update service_params
      redirect_to service_path(@service), notice: 'Has editado un servicio'
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @service.soft_delete

    redirect_to user_path(current_user), notice: 'Has eliminado un servicio'
  end

  def filter
    if params[:category_id].present?
      @services = Category.find(params[:category_id]).services
    elsif params[:keyword].present?
      @services = Service.by_keyword(params[:keyword])
    else
      @services = Service.all
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('services', partial: 'services/services', locals: { services: @services.active.order(created_at: :desc).page(params[:page]).per(10) })}
    end
  end


  private

  def service_params
    params.require(:service).permit(:title, :detail, :category_id, :image)
  end

  def set_service
    @service = Service.find_by(id: params[:id])
  end

  def authorize_user
    return if @service.user.eql? current_user

    redirect_to service_path(@service), notice: 'No tienes autorización'
  end
end
