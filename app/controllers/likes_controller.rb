class LikesController < ApplicationController
  # ユーザーが認証されているかどうかを確認するアクション
  before_action :authenticate_user

  # いいねを作成するアクション
  def create
    # URLからservice_idを使用してServiceオブジェクトを検索
    # paramsは、HTTPリクエストを通じて送信されたパラメータを含むハッシュです。GETやPOSTリクエストで送信されたデータが含まれます。例えば、ユーザーがフォームを通じてデータを送信したり、URLの一部としてパラメータを送信したりした場合です。
    # ハッシュ params から特定のキー :service_id に関連付けられた値を取得
    service = Service.find(params[:service_id])

    # Serviceが見つからない場合、トップページにリダイレクトし、アラートを表示
    unless service
      redirect_to root_path, alert: 'Service not found.'
      return
    end

    # 現在のユーザーで、サービスIDを使用していいねを作成
    # service_id は、Like モデル内の外部キーであり、どのサービスが「いいね」されたかを示します。
    @like = current_user.likes.create(service_id: service.id)

    # サービスの詳細ページにリダイレクト
    redirect_to service_path(service.id)
  end

  # いいねを削除するアクション
  def destroy
    # 現在のユーザーIDとサービスIDでLikeオブジェクトを検索し、存在しない場合は例外を投げる
    # Like.find_by! メソッドは、指定された条件でデータベース内の likes テーブルを検索し、条件に合致する最初のレコードを返します。
    # 感嘆符 ! がついているバージョンを使用すると、条件に合致するレコードが一つも見つからない場合に ActiveRecord::RecordNotFound 例外が発生します。
    # これにより、アプリケーションは特定のフローを中断させるか、エラーページにリダイレクトさせることができます。
    @like = Like.find_by!(user_id: current_user.id, service_id: params[:service_id])

    # いいねを削除
    @like.destroy
    
    # サービスの詳細ページにリダイレクト
    redirect_to service_path(params[:service_id])
  end
end
