class ServiceReviewsController < ApplicationController
  before_action :require_login
  before_action :set_review_params, only: [:new, :create]

  def new
    @review = ServiceReview.new
    @review.service_id = @service_id
    @review.user_id = @current_user.id if @current_user # ログインしているユーザーのIDをセット
  end

  def create
    @review = ServiceReview.new(review_params)
    if @review.save
      flash[:notice] = 'La evaluación ha sido registrada.'
      redirect_to("/users/#{@current_user.id}")
    else
      render 'new'
    end
  end

  private

  def require_login
    unless @current_user
      flash[:error] = 'ログインが必要です。'
      redirect_to login_path
    end
  end

  def review_params
    params.require(:service_review).permit(:user_id, :service_id, :rating, :comment)
  end

  def set_review_params
    @service_id = params[:service_id]
  end

  def find_order_by_service_and_user(service, user)
    # ここに適切なコードを記述して、該当するサービスとユーザーに関連する注文履歴を取得するロジックを実装してください。
    # 例えば、Orderモデルに対する関連付けやメソッドを使用して注文履歴を取得することが考えられます。
  end
end
