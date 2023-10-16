class UsersController < ApplicationController
  before_action :authenticate_user, except: [:show]
  before_action :find_active_user, only: %i[show likes orders sales]

  def show
    @services = @user.services.active.order(created_at: :desc)
    @average_rating = @user.average_service_rating

    # 以下のコードを追加して@reviewsをセットしてください
    service_ids = @user.services.pluck(:id)
    @reviews = Review.where(service_id: service_ids).order(created_at: :desc).page(params[:page]).per(10)
  end

  def likes
    # set_services_and_rating_for
    @likes = Like.joins(:service).merge(Service.active).where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(30)
  end

  def orders
    # set_services_and_rating_for
    @orders = Order.where(buyer_id: current_user.id).order(created_at: :desc).page(params[:page]).per(30)
  end

  def sales
    # set_services_and_rating_for
    @sales = Order.where(seller_id: current_user.id).order(created_at: :desc).page(params[:page]).per(30)
  end

  def destroy
    # [重要度: 高] idの値を偽装することで任意のユーザの削除が可能になってます
    user_id = params[:id]
    @user = User.find(user_id)
    @user.soft_delete
  end

  private

  # def set_services_and_rating_for
  #   @average_rating = 0 # total_count > 0 ? total_reviews / total_count.to_f : nil
  # end

  def find_active_user
    # [重要度: 中] find_byではなく、findの利用を検討してください。
    @user = User.active.find_by(id: params[:id])

    if @user.nil?
      render file: "#{Rails.root}/public/404.html"
    else
      # [重要度: 中] @userには既に値が入ってますので再代入の必要はありません。
      # またset_userにも同様の表記があります
      # 同様の文章が複数あると、編集時の作業漏れにつながります
      @user = User.active.find(params[:id])
    end
  end

  def set_user
    @user = User.active.find(params[:id])
  end
end
