class LikesController < ApplicationController
  before_action :authenticate_user

  def create
    # [重要度: 低] new->saveと順に行うだけであれば、createを利用した方がシンプルに記載が可能です。→ 完了
    # [重要度: 中] service_idに適当なパラメータを渡すと、ゴミデータの作成が可能になります。ServiceとLikeの外部キー制約の作成・Serviceの存在確認をするなど検討してください → 完了
    service = Service.find_by(id: params[:service_id])

    unless service
      redirect_to root_path, alert: 'Service not found.'
      return
    end

    @like = current_user.likes.create(service_id: service.id)

    redirect_to service_path(service.id)
  end

  def destroy
    # [重要度: 中] service_idに適当なパラメータを渡すと500番台のエラーとなります。400番台で落とすためにも、find_byではなく、find_by!の利用を検討してください。→ 完了
    @like = Like.find_by!(user_id: current_user.id, service_id: params[:service_id])

    @like.destroy
    redirect_to service_path(params[:service_id])
  end
end
