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
      user_id: @current_user.id
    )
    if @service.save
      flash[:notice] = "投稿を作成しました"
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
    @service.save
    if @service.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/services/index")
    else
      render("services/edit")
    end
  end

  def destroy
    @service = Service.find_by(id: params[:id])
    @service.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/services/index")
  end

  def ensure_correct_user
    @service = Service.find_by(id: params[:id])
    if @service.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/services/index")
    end
  end
end
