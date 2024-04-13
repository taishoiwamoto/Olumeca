class ServicesController < ApplicationController
  # ユーザー認証を除く、index, show, filterアクションで行う
  before_action :authenticate_user, except: [:index, :show, :filter]
  # 特定のアクションでサービスを設定
  before_action :set_service, only: %i[edit update destroy]

  # サービスの一覧表示
  def index
    # Active Recordの`preload`メソッドを使ってN+1問題を解決しつつ、アクティブなサービスを降順にページネーションで表示
    #元々preload(:user)だったものをpreload(:reviews)に変更済み
    #serviceの配列からreviewを取るコードになっているので、正しくはController側で以下のように実装するとN+1を回避できる
    #https://zenn.dev/gottsu/articles/914d45332450a3
    #https://github.com/taishoiwamoto/Olumeca/blob/85e8220a2683d08699ab638fffef6e72be620079/app/views/services/_services.html.erb#L16
    #rails sでサーバーを起動したとき、そのコンソールに色々と文字が出力される。
    #ここはサーバーの稼働ログが出力される場所で、そこにSQLのログも出力されます。
    #それを見て、N+1が修正されたかどうかが判断できる
    @services = Service.active.preload(:reviews).order(created_at: :desc).page(params[:page]).per(30)
  end

  # サービスの詳細表示
  def show
    # 特定のサービスを取得し、関連するユーザーとレビューも事前に読み込む
    @service = Service.active.preload(:user).find(params[:id])
    @user = @service.user
    @user_has_liked = Like.user_and_service(current_user.id, @service.id) if current_user
    @reviews = @service.reviews.preload(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  # 新規サービス作成ページ
  def new
    @service = Service.new
  end

  # サービスの新規作成
  def create
    @service = current_user.services.build service_params

    if @service.save
      redirect_to service_path(@service), notice: "Has creado un servicio"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # サービスの編集ページ
  def edit; end

  # サービスの更新
  def update
    if @service.update service_params
      redirect_to service_path(@service), notice: 'Has editado un servicio'
    else
      render :edit, status: :unprocessable_entity
    end
  end


  # サービスの論理削除
  def destroy
    @service.soft_delete

    redirect_to user_path(current_user), notice: 'Has eliminado un servicio'
  end

  # サービスのフィルタリング
  def filter
    @services = Service.all

    # カテゴリによる絞り込み
    #未対応 [重要度: 低] Serviceテーブルのデータ量が多くなった際に時間がかかる可能性が高いです。LIKE検索の有効的な軽量化方法は難しいため、外部の検索サービスなどの利用をお勧めします。service.rbの二行目の箇所。規模がかなり大きくなる前に対策をした方が良い程度。サービステーブルが万くらいまでは気にしなくても良さそう。
    if params[:category_id].present?
      @services = @services.where(category_id: params[:category_id])
    end

    # キーワードによる絞り込み
    if params[:keyword].present?
      @services = @services.by_keyword(params[:keyword])
    end

    # ユーザーの事前読み込みとアクティブなサービスの降順にページネーションで表示
    @services = @services.preload(:user).active.order(created_at: :desc).page(params[:page]).per(30)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('services', partial: 'services/services', locals: { services: @services })}
    end
  end


  private

  # サービスのパラメータ
  def service_params
    params.require(:service).permit(:title, :detail, :category_id, :image)
  end

  # 編集・更新・削除用にサービスを設定
  def set_service
    @service = Service.preload(:user).find(params[:id])

    unless @service.user.eql? current_user
      redirect_to service_path(@service), notice: 'No tienes autorización' and return
    end
  end
end
