class LikesController < ApplicationController
  # ユーザーが認証されているかどうかを確認するアクション
  before_action :authenticate_user

  # いいねを作成するアクション
  def create
    # URLからservice_idを使用してServiceオブジェクトを検索
    service = Service.find(params[:service_id])

    # Serviceが見つからない場合、トップページにリダイレクトし、アラートを表示
    unless service
      redirect_to root_path, alert: 'Service not found.'
      return
    end

    # 現在のユーザーで、サービスIDを使用していいねを作成
    @like = current_user.likes.create(service_id: service.id)

    # サービスの詳細ページにリダイレクト
    redirect_to service_path(service.id)
  end

  # いいねを削除するアクション
  def destroy
    # 現在のユーザーIDとサービスIDでLikeオブジェクトを検索し、存在しない場合は例外を投げる
    @like = Like.find_by!(user_id: current_user.id, service_id: params[:service_id])

    # いいねを削除
    @like.destroy
    
    # サービスの詳細ページにリダイレクト
    redirect_to service_path(params[:service_id])
  end
end
