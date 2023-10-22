class UsersController < ApplicationController
  before_action :authenticate_user, except: [:show]
  before_action :find_active_user, only: %i[show likes orders sales]

  def show
    @services = @user.services.active.order(created_at: :desc)
    @average_rating = @user.average_service_rating

    service_ids = @user.services.pluck(:id)
    @reviews = Review.where(service_id: service_ids).order(created_at: :desc).page(params[:page]).per(10)
  end

  def likes
    #完了 [優先度: 中] Viewに表示したいのは、Likeの情報ではなく、Serviceの情報かと思います。
    # なので、Serviceを中心にクエリを組み立ててください
    # @services = Service.joins(:likes).where(likes: { user_id: current_user.id }).order("likes.created_at desc").page(params[:page]).per(30)
    # ↑実際に動かしてないので、動かないかもしれません。。。。

    @services = Service.joins(:likes).where(likes: { user_id: current_user.id }).order("likes.created_at desc").page(params[:page]).per(30)
  end

  def orders
    @orders = Order.where(buyer_id: current_user.id).order(created_at: :desc).page(params[:page]).per(30)

    service_ids = @orders.map(&:service_id)
    @reviews_by_user = Review.where(user_id: current_user.id, service_id: service_ids)
  end

  def sales
    @sales = Order.where(seller_id: current_user.id).order(created_at: :desc).page(params[:page]).per(30)
  end

  def destroy
    if current_user.soft_delete
      redirect_to root_path, notice: 'Has eliminado tu cuenta.'
    else
      redirect_to user_path(current_user), alert: 'No se pudo eliminar tu cuenta.'
    end
  end

  private

  def find_active_user
    @user = User.active.find(params[:id])
  end
end
