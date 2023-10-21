class ReviewsController < ApplicationController
  before_action :authenticate_user
  before_action :set_service
  before_action :set_review, only: [:new, :create, :edit, :update]

  def new
    if @service.reviews.where(user: current_user).exists?
      redirect_to service_path(@service), notice: 'Ya has evaluado este servicio.'
    else
      @review = @service.reviews.build(user: current_user)
    end
  end

  def create
    @review = @service.reviews.build review_params
    @review.user = current_user

    if @review.save
      redirect_to orders_user_path(current_user), notice: 'La evaluación ha sido creada.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to orders_user_path(current_user), notice: 'La evaluación ha sido actualizada.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def set_review
    @review = Review.find_by(id: params[:id]) || @service.reviews.where(user: current_user).first

    authorized_user if %w[edit update].include?(action_name)
    check_review_possibility if %w[new create].include?(action_name)
  end

  def authorized_user
    # [重要度: 低] @review.user_id == current_user.idとした方が、userテーブルへのselectを減らせるため、より高速な動作が見込めます → 完了
    # [重要度: 中] set_reviewメソッド内で行えば、この処理の呼び出し漏れを防ぐことが可能です → 完了
    return if @review.user_id == current_user.id
    redirect_to root_path, notice: 'No tiene permiso para editar esta evaluación.'
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def set_service
    @service = Service.find(params[:service_id])
  end

  def check_review_possibility
    # [重要度: 中] set_reviewメソッド内で行えば、この処理の呼び出し漏れを防ぐことが可能です → 完了
    # すみません、、、私の記載ミスです。ちょっとこれを書いた意図を覚えていないのでおそらくですが、set_reviewではなく、set_serviceと言いたかったのではないかと予想します。
    # set_reviewにしてしまうと、set_review内の処理が複雑になりますし、適切なserviceか？を見たいのにset_reviewではおかしいですね。。。。
    purchased = Order.exists?(buyer: current_user, service: @service)

    reviewed = Order.service_reviewed_by_user?(current_user.id, @service.id)

    unless purchased && !reviewed
      redirect_to orders_user_path(current_user), notice: 'No puedes evaluar este servicio.'
    end
  end
end
