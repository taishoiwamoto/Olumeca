class ReviewsController < ApplicationController
  # 全てのアクションでユーザーが認証されているかを確認
  before_action :authenticate_user
  # パラメータからサービスを設定
  before_action :set_service
  # 特定のアクションでレビューを設定
  before_action :set_review, only: [:new, :create, :edit, :update]

  # 新規レビュー作成ページ
  def new
    # 既にレビューが存在する場合はサービスページにリダイレクト
    if @service.reviews.where(user: current_user).exists?
      redirect_to service_path(@service), notice: 'Ya has evaluado este servicio.'
    else
      # レビューを新規作成
      @review = @service.reviews.build(user: current_user)
    end
  end

  # レビューをデータベースに保存
  def create
    @review = @service.reviews.build review_params
    @review.user = current_user

    if @review.save
      redirect_to orders_user_path(current_user), notice: 'La evaluación ha sido creada.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # レビュー編集ページ
  def edit; end

  # レビューの更新処理
  def update
    if @review.update(review_params)
      redirect_to orders_user_path(current_user), notice: 'La evaluación ha sido actualizada.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  # サービスを設定し、レビュー可能かどうかをチェック
  def set_service
    @service = Service.includes(:reviews).find(params[:service_id])

    check_review_possibility if %w[new create].include?(action_name)
  end

  # レビューを設定し、ユーザーが編集可能かどうかをチェック
  def set_review
    @review = Review.find_by(id: params[:id]) || @service.reviews.where(user: current_user).first

    authorized_user if %w[edit update].include?(action_name)
  end

  # 編集権限の確認
  def authorized_user
    return if @review.user_id == current_user.id
    redirect_to root_path, notice: 'No tiene permiso para editar esta evaluación.'
  end

  # レビューパラメータの許可
  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  # レビューが可能かどうかの確認
  def check_review_possibility
    purchased = Order.exists?(buyer: current_user, service: @service)

    reviewed = Order.service_reviewed_by_user?(current_user.id, @service.id)

    unless purchased && !reviewed
      redirect_to orders_user_path(current_user), notice: 'No puedes evaluar este servicio.'
    end
  end
end
