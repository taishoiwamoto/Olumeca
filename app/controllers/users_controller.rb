class UsersController < ApplicationController
  # ユーザー認証を除く、showアクションで行う
  before_action :authenticate_user, except: [:show]
  # show, likes, orders, salesアクションでアクティブなユーザーを設定
  before_action :find_active_user, only: %i[show likes orders sales]

  # ユーザーの詳細ページ
  def show
    # ユーザーのアクティブなサービスを降順に表示
    @services = @user.services.active.order(created_at: :desc)
    # ユーザーの平均評価
    @average_rating = @user.average_service_rating

    # 表示するサービスIDを取得
    service_ids = @services.pluck(:id)
    # 関連するレビューを取得し、ページネーションで表示
    @reviews = Review.includes(:service, :user).where(service_id: service_ids).order(created_at: :desc).page(params[:page]).per(10)
  end

  # ユーザーが「いいね」したサービス一覧
  def likes
    # 「いいね」したサービスを取得し、ページネーションで表示
    @services = Service.joins(:likes).preload(:user).where(likes: { user_id: current_user.id }).where(deleted_at: nil).order("likes.created_at desc").page(params[:page]).per(30)
  end

  # ユーザーの注文一覧
  def orders
    # ユーザーの注文を取得し、ページネーションで表示
    @orders = Order.where(buyer_id: current_user.id).includes(:seller, service: :user).order(created_at: :desc).page(params[:page]).per(30)

    # 注文に関連するサービスIDを取得
    service_ids = @orders.map(&:service_id)
    # ユーザーが投稿したレビューを取得
    @reviews_by_user = Review.where(user_id: current_user.id, service_id: service_ids)
  end

  # ユーザーの売上一覧
  def sales
    # ユーザーの売上を取得し、ページネーションで表示
    @sales = Order.where(seller_id: current_user.id).includes(:buyer, service: :user).order(created_at: :desc).page(params[:page]).per(30)
  end

  # ユーザーのアカウント削除
  def destroy
    if current_user.soft_delete
      redirect_to root_path, notice: 'Has eliminado tu cuenta.'
    else
      redirect_to user_path(current_user), alert: 'No se pudo eliminar tu cuenta.'
    end
  end

  private

  # アクティブなユーザーを設定
  def find_active_user
    @user = User.active.find(params[:id])
  end
end
