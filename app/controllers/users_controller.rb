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
    # [優先度: 中] Viewに表示したいのは、Likeの情報ではなく、Serviceの情報かと思います。
    # なので、Serviceを中心にクエリを組み立ててください
    # @services = Service.joins(:likes).where(likes: { user_id: current_user.id }).order("likes.created_at desc").page(params[:page]).per(30)
    # ↑実際に動かしてないので、動かないかもしれません。。。。

    @likes = Like.joins(:service).merge(Service.active).where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(30)
  end

  def orders
    @orders = Order.where(buyer_id: current_user.id).order(created_at: :desc).page(params[:page]).per(30)
  end

  def sales
    @sales = Order.where(seller_id: current_user.id).order(created_at: :desc).page(params[:page]).per(30)
  end

  def destroy
    # [重要度: 高] idの値を偽装することで任意のユーザの削除が可能になってます → 完了
    if current_user.soft_delete
      redirect_to root_path, notice: 'Has eliminado tu cuenta.'
    else
      redirect_to user_path(current_user), alert: 'No se pudo eliminar tu cuenta.'
    end
  end

  private

  def find_active_user
    # [重要度: 中] find_byではなく、findの利用を検討してください。→ 完了
    @user = User.active.find(params[:id])
    # [重要度: 中] @userには既に値が入ってますので再代入の必要はありません。→ 完了
    # またset_userにも同様の表記があります
    # 同様の文章が複数あると、編集時の作業漏れにつながります
  end
end
