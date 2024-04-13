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
    # .pluck(:id) を使用して、そのコレクション内の全サービスオブジェクトから id 属性のみを抽出し、配列として service_ids に格納しています。
    # .pluck メソッドは、指定されたカラムの値だけを直接データベースから取り出すので、メモリ使用量と処理時間の節約に効果的です。
    service_ids = @services.pluck(:id)
    # 関連するレビューを取得し、ページネーションで表示
    @reviews = Review.includes(:service, :user).where(service_id: service_ids).order(created_at: :desc).page(params[:page]).per(10)
  end

  # ユーザーが「いいね」したサービス一覧
  def likes
    # 「いいね」したサービスを取得し、ページネーションで表示
    # 各サービスに紐付けられたユーザー情報をあらかじめ読み込む（プリロードする）ことで、サービスに紐付くユーザー情報を表示する際に発生する追加のクエリ（N+1クエリ問題）を防ぎます。
    # where(likes: { user_id: current_user.id }):で、likes テーブルにある user_id カラムが現在ログインしているユーザー（current_user.id）と一致するレコードのみをフィルタリングします。これにより、現在のユーザーが「いいね」したサービスのみが取得されます。
    @services = Service.joins(:likes).preload(:user).where(likes: { user_id: current_user.id }).where(deleted_at: nil).order("likes.created_at desc").page(params[:page]).per(30)
  end

  # ユーザーの注文一覧
  def orders
    # ユーザーの注文を取得し、ページネーションで表示
    # 注文に関連する seller（販売者）と、service（サービス）およびそのサービスに紐づく user（サービス提供者）の情報をプリロードします。これにより、注文に関連するデータを表示する際に発生する追加のクエリ（N+1クエリ問題）を防ぎます。
    @orders = Order.where(buyer_id: current_user.id).includes(:seller, service: :user).order(created_at: :desc).page(params[:page]).per(30)

    # 注文に関連するサービスIDを取得
    # 特定の @orders コレクション（Order オブジェクトの配列）から各注文に関連付けられている service_id を取得し、それらの ID を配列として service_ids に格納
    # mapメソッドは、コレクション（例えば配列や範囲）の各要素に対してブロック内の処理を適用し、結果を新しい配列として返します。
    # :service_id: service_id はシンボルで、これは Order オブジェクトの service_id 属性（メソッド）を指します。
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
