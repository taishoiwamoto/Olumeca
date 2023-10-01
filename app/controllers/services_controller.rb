class ServicesController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @services = Service.active.order(created_at: :desc).page(params[:page]).per(10)
    puts "@service object class: #{@services.class}"
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
    @service.plans.build
  end

  def create
    @service = current_user.services.create(service_params)

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
    @service.soft_delete
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

  def filter
    @category = Category.find(params[:services][:category_id])

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('services', partial: 'services/services', locals: { services: @category.services.active.order(created_at: :desc).page(params[:page]).per(10) })}
    end
  end

  private

  def service_params
    params.require(:service).permit(:title, :detail, :category_id, :image,
                                    plans_attributes: [:title, :detail, :price, :delivery_method, :_destroy, :id])
  end
end
