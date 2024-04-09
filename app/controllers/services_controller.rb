class ServicesController < ApplicationController
  before_action :authenticate_user, except: [:index, :show, :filter]
  before_action :set_service, only: %i[edit update destroy]

  def index
    @services = Service.active.preload(:user).order(created_at: :desc).page(params[:page]).per(30)
  end

  def show
    @service = Service.active.preload(:user).find(params[:id])
    @user = @service.user
    @user_has_liked = Like.user_and_service(current_user.id, @service.id) if current_user
    @reviews = @service.reviews.preload(:user).order(created_at: :desc).page(params[:page]).per(10)
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
    @services = Service.all

    #未対応 [重要度: 低] Serviceテーブルのデータ量が多くなった際に時間がかかる可能性が高いです。LIKE検索の有効的な軽量化方法は難しいため、外部の検索サービスなどの利用をお勧めします。service.rbの二行目の箇所。規模がかなり大きくなる前に対策をした方が良い程度。サービステーブルが万くらいまでは気にしなくても良さそう。
    if params[:category_id].present?
      @services = @services.where(category_id: params[:category_id])
    end

    if params[:keyword].present?
      @services = @services.by_keyword(params[:keyword])
    end

    @services = @services.preload(:user).active.order(created_at: :desc).page(params[:page]).per(30)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('services', partial: 'services/services', locals: { services: @services })}
    end
  end


  private

  def service_params
    params.require(:service).permit(:title, :detail, :category_id, :image)
  end

  def set_service
    @service = Service.preload(:user).find(params[:id])

    unless @service.user.eql? current_user
      redirect_to service_path(@service), notice: 'No tienes autorización' and return
    end
  end
end
