class ServicesController < ApplicationController
  before_action :authenticate_user, except: [:index, :show, :filter]
  before_action :set_service, only: %i[edit update destroy]

  def index
    # [重要度: 低] Serviceの量が増えてきたときに動作が遅くなる可能性があります。DBに適切なインデックスを張ることをお勧めします → 完了
    @services = Service.active.order(created_at: :desc).page(params[:page]).per(30)
  end

  def show
    # [重要度: 低] find_byではなく、findの利用を検討してください。それだけで、見つからない際は404エラーを返却可能です → 完了
    @service = Service.active.find(params[:id])
    if @service.nil?
      render file: "#{Rails.root}/public/404.html"
    else
      @user = @service.user
      # [重要度: 低] @service.likes.countの方が分かりやすいかと思います → 完了
      @likes_count = @service.likes.count
      @reviews = @service.reviews.order(created_at: :desc).page(params[:page]).per(10)
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
    @services = Service.all

    # [重要度⭐️: 低] Serviceテーブルのデータ量が多くなった際に時間がかかる可能性が高いです。LIKE検索の有効的な軽量化方法は難しいため、外部の検索サービスなどの利用をお勧めします。
    if params[:category_id].present?
      @services = @services.where(category_id: params[:category_id])
    end

    if params[:keyword].present?
      @services = @services.by_keyword(params[:keyword])
    end

    @services = @services.active.order(created_at: :desc).page(params[:page]).per(10)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('services', partial: 'services/services', locals: { services: @services })}
    end
  end


  private

  def service_params
    params.require(:service).permit(:title, :detail, :category_id, :image)
  end

  def set_service
    @service = Service.find(params[:id])

    # [重要度: 中] set_serviceメソッド内で行えば、この処理の呼び出し漏れを防ぐことが可能です → 完了
    unless @service.user.eql? current_user
      redirect_to service_path(@service), notice: 'No tienes autorización' and return
    end
  end


    # [重要度: 中] set_serviceメソッド内で行えば、この処理の呼び出し漏れを防ぐことが可能です → 完了
end
