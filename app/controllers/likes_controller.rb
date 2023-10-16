class LikesController < ApplicationController
  before_action :authenticate_user

  def create
    # [重要度: 低] new->saveと順に行うだけであれば、createを利用した方がシンプルに記載が可能です。
    # [重要度: 中] service_idに適当なパラメータを渡すと、ゴミデータの作成が可能になります。ServiceとLikeの外部キー制約の作成・Serviceの存在確認をするなど検討してください
    @like = Like.new(user_id: current_user.id, service_id: params[:service_id])
    @like.save
    redirect_to service_path(params[:service_id])
  end

  def destroy
    # [重要度: 中] service_idに適当なパラメータを渡すと500番台のエラーとなります。400番台で落とすためにも、find_byではなく、find_by!の利用を検討してください。
    @like = Like.find_by(user_id: current_user.id, service_id: params[:service_id])
    @like.destroy
    redirect_to service_path(params[:service_id])
  end
end
