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
  end


  def new
    @service = Service.new
    2.times { @service.plans.build }
  end

  def create
    @service = Service.new(service_params.merge(user_id: current_user.id))

    if @service.save
      redirect_to service_path(@service), notice: "Has creado un servicio"
    else
      @service.plans.build if @service.plans.blank?
      render :new
    end
  end


  def edit
    @service = Service.find_by(id: params[:id])
  end

  def update
    @service = Service.find_by(id: params[:id])
    if @service.update(service_params)
      if params[:service][:image] && params[:service][:image].respond_to?(:read)
        @service.image = "#{@service.id}.jpg"
        image = params[:service][:image]
        File.binwrite("public/service_images/#{@service.image}", image.read)
        @service.save
      elsif @service.image.blank?
        @service.update(image: "default_service.jpg")
      end
      flash[:notice] = "Has editado un servicio"
      redirect_to service_path(@service)
    else
      render :edit
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
                                    plans_attributes: [:id, :title, :detail, :price, :delivery_method, :_destroy])
   #params.require(:service).permit(:title, :detail, :category, :image)
  end
end
