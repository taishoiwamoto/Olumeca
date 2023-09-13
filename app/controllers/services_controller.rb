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
    #reviews_through_plans = @service.plans.includes(:reviews).map(&:reviews).flatten
    #reviews = Kaminari.paginate_array(reviews_through_plans).page(params[:page]).per(10)
  end


  def new
    @service = Service.new
    1.times { @service.plans.build }
  end

  def create
    @service = Service.new(service_params.merge(user_id: current_user.id))
    logger.debug "plans list content " + @service.plans.inspect
    if @service.save
      if params[:service][:image] && params[:service][:image].respond_to?(:read)
        @service.image = "#{@service.id}.jpg"
        image = params[:service][:image]
        File.binwrite("public/service_images/#{@service.image}", image.read)
        @service.save
      elsif @service.image.blank?
        @service.update(image: "default_service.jpg")
      end

      flash[:notice] = "Has creado un servicio"
      redirect_to service_path(@service)
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
    if @service.user_id != current_user.id
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
