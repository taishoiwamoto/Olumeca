class ServicesController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @services = Service.all.order(created_at: :desc)
  end

  def show
    @service = Service.find_by(id: params[:id])
    @user = @service.user
    @likes_count = Like.where(service_id: @service.id).count
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(
      title: params[:title],
      user_id: @current_user.id,
      detail: params[:detail],
      category: params[:category],
      hour: params[:hour],
      price: params[:price],
      method: params[:method],
      image: params[:image]
    )

    if params[:image] && params[:image].respond_to?(:read)
      @service.image = "#{@service.id}.jpg"
      image = params[:image]
      File.binwrite("public/service_images/#{@service.image}", image.read)
    else
      @service.image = "default_service.jpg"
    end

    if @service.save
      flash[:notice] = "Has creado un servicio"
      redirect_to("/services/index")
    else
      render("services/new")
    end
  end

  def edit
    @service = Service.find_by(id: params[:id])
  end

  def update
    @service = Service.find_by(id: params[:id])
    @service.title = params[:title]
    @service.detail = params[:detail]
    @service.category = params[:category]
    @service.hour = params[:hour]
    @service.price = params[:price]
    @service.method = params[:method]
    if params[:image]
      @service.image = "#{@service.id}.jpg"
      image = params[:image]
      File.binwrite("public/service_images/#{@service.image}", image.read)
    end

    @service.save
    if @service.save
      flash[:notice] = "Has editado un servicio"
      redirect_to("/services/index")
    else
      render("services/edit")
    end
  end

  def destroy
    @service = Service.find_by(id: params[:id])
    @service.destroy
    flash[:notice] = "Has eliminado un servicio"
    redirect_to("/services/index")
  end

  def ensure_correct_user
    @service = Service.find_by(id: params[:id])
    if @service.user_id != @current_user.id
      flash[:notice] = "No tienes autorización"
      redirect_to("/services/index")
    end
  end
end
