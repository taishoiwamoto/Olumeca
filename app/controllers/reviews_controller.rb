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
    # .build(user: current_user)：reviews コレクションに新しい Review オブジェクトをメモリ上に作成しますが、この時点ではデータベースには保存されません。
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
  # Service.includes(:reviews): Service モデルからデータを取得する際に、関連する reviews（レビュー）も一緒に事前読み込み（Eager Loading）します。これにより、後続の処理でレビュー情報が必要になった時、効率的にアクセスできるようになり、N+1 クエリ問題を防ぐことができます。
  def set_service
    @service = Service.includes(:reviews).find(params[:service_id])

    # %w[new create].include?(action_name): 現在実行中のアクションが 'new' または 'create' であるかどうかをチェックします。これは、レビュー可能かどうかのチェックが新規作成または作成処理のコンテキストでのみ必要とされる場合に有用です。
    check_review_possibility if %w[new create].include?(action_name)
  end

  # レビューを設定し、ユーザーが編集可能かどうかをチェック
  def set_review
    # Review.find_by(id: params[:id]): Review モデルから、params[:id]（リクエストから送られたIDパラメータ）に基づいてレビューを検索します。find_by は一致する最初のレコードを返すか、見つからない場合は nil を返します。
    # @service.reviews.where(user: current_user).first: もし上記でレビューが見つからなかった場合、ログインしているユーザー（current_user）が書いた @service（事前にセットされているサービスのインスタンス）に関連するレビューのうち最初のものを取得します。これは、ユーザーが以前に書いたレビューを編集する状況でよく使用されます。
    @review = Review.find_by(id: params[:id]) || @service.reviews.where(user: current_user).first

    # %w[edit update].include?(action_name): 現在のアクションが 'edit' または 'update' であるかを確認します。これにより、これらのアクションに対して特定の権限確認を行う必要がある場合に処理を実行します。
    authorized_user if %w[edit update].include?(action_name)
  end

  # 編集権限の確認
  def authorized_user
    # この行は、@review の user_id（レビューを作成したユーザーのID）と current_user.id（現在ログインしているユーザーのID）が等しいかどうかを確認します。
    # もし両者が等しければ、メソッドから早期にリターン（処理を終了）します。これは、ユーザーがそのレビューを編集する権限があることを意味し、追加のアクションは不要です。
    return if @review.user_id == current_user.id
    # 権限のチェックで return されなかった場合（つまり、ログインユーザーがレビューの作成者ではない場合）、この行が実行されます。
    redirect_to root_path, notice: 'No tiene permiso para editar esta evaluación.'
  end

  # レビューパラメータの許可
  def review_params
    # この部分は params ハッシュから :review キーを必須とします。これは、フォームから送信されたデータが review オブジェクトの属性を含むことを確認するためのものです。もし :review キーが存在しなければ、エラー（ActionController::ParameterMissing）が発生し、処理が中断されます。
    # .permit メソッドは、指定されたキー（この場合は :rating と :comment）のみを許可します。これにより、これらのフィールド以外にフォームで送信された追加のパラメータがあった場合、それらが無視されるため、マスアサインメントの脆弱性を防ぐことができます。
    params.require(:review).permit(:rating, :comment)
  end

  # レビューが可能かどうかの確認
  def check_review_possibility
    # 購入済み
    purchased = Order.exists?(buyer: current_user, service: @service)

    # レビュー済み
    reviewed = Order.service_reviewed_by_user?(current_user.id, @service.id)

    #「ユーザーがサービスを購入しており、かつそのサービスに対してレビューをしていない場合」以外のときに処理
    unless purchased && !reviewed
      redirect_to orders_user_path(current_user), notice: 'No puedes evaluar este servicio.'
    end
  end
end
