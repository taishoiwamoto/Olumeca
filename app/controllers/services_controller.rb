class ServicesController < ApplicationController
  # ユーザー認証を除く、index, show, filterアクションで行う
  before_action :authenticate_user, except: [:index, :show, :filter]
  # 特定のアクションでサービスを設定
  # only: %i[edit update destroy]: このオプションは、before_actionが適用されるアクションを限定します。ここでは、:edit、:update、:destroy の各アクションが実行される前にset_serviceメソッドが呼び出されます。この指定により、他のアクションではset_serviceメソッドは実行されません。
  # 通常、set_serviceメソッドは指定されたIDに基づいてServiceオブジェクトをデータベースから取得し、それをインスタンス変数（例えば@service）に格納することで、edit、update、destroyアクションが利用できるようにします。
  before_action :set_service, only: %i[edit update destroy]

  # サービスの一覧表示
  def index
    # Active Recordの`preload`メソッドを使ってN+1問題を解決しつつ、アクティブなサービスを降順にページネーションで表示
    #元々preload(:user)だったものをpreload(:reviews)に変更済み
    #serviceの配列からreviewを取るコードになっているので、以下のように実装するとN+1を回避できる
    #https://zenn.dev/gottsu/articles/914d45332450a3
    #https://github.com/taishoiwamoto/Olumeca/blob/85e8220a2683d08699ab638fffef6e72be620079/app/views/services/_services.html.erb#L16
    # 確認方法：rails sでサーバーを起動したとき、そのコンソールに色々と文字が出力される。ここはサーバーの稼働ログが出力される場所で、そこにSQLのログも出力されます。それを見て、N+1が修正されたかどうかが判断できる
    # page(params[:page]) はページネーションのためのメソッドで、通常は kaminari や will_paginate のようなページネーションライブラリによって提供されます。これにより、大量のレコードを扱う際にユーザーインターフェースが過負荷になることを防ぎます。params[:page] は現在のページ番号を指定し、これに基づいて表示するレコードの範囲が決まります。
    @services = Service.active.preload(:reviews).order(created_at: :desc).page(params[:page]).per(30)
  end

  # サービスの詳細表示
  def show
    # 特定のサービスを取得し、関連するユーザーとレビューも事前に読み込む
    # preload(:user)があることで処理速度の改善を確認
    @service = Service.active.preload(:user).find(params[:id])
    @user = @service.user
    @user_has_liked = Like.user_and_service(current_user.id, @service.id) if current_user
    # preload(:user)によりUser Loadの削減を確認
    @reviews = @service.reviews.preload(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  # 新規サービス作成ページ
  def new
    @service = Service.new
  end

  # サービスの新規作成
  def create
    # build メソッドは、新しい Service オブジェクトをメモリ上に作成しますが、この時点ではデータベースには保存されません。build は新しいレコードをインスタンス化するために使われ、特に関連付けられたオブジェクトのコレクションに新しいオブジェクトを追加する際に便利です。
    # service_params は、通常コントローラ内で定義されるプライベートメソッドです。このメソッドはストロングパラメータを使用しており、フォームから送信されたデータから安全にパラメータを取り出すために使用されます。具体的には、許可されたパラメータ（例：サービス名、説明など）のみを含むハッシュを返します。
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
    # service_params は、通常コントローラ内で定義されるプライベートメソッドです。このメソッドはストロングパラメータを使用しており、フォームから送信されたデータから安全にパラメータを取り出すために使用されます。具体的には、許可されたパラメータ（例：サービス名、説明など）のみを含むハッシュを返します。
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
    # preload(:user)によりUser Loadの読み込み回数削減を確認
    @services = @services.preload(:user).active.order(created_at: :desc).page(params[:page]).per(30)

    # ページ全体をリロードすることなく、ページの一部分だけをサーバーからの新しい情報で更新するために使われます。 
    # respond_to ブロックを使用して、異なるフォーマットに応じた応答を設定します。
    # respond_to do |format| の箇所は、Ruby on Railsにおいて、クライアントからのリクエストに応じて異なるフォーマットでレスポンスを返すためのメソッドを設定する場所です。
    # このブロックを使用することで、同一のアクション（この場合は filter アクション）において、リクエストされたフォーマットに応じた適切な処理を行い、それぞれ異なるフォーマットでデータを返すことができます。
    respond_to do |format|
      # format.turbo_stream ブロックを使用して、Turbo Stream形式での応答を定義します。
      format.turbo_stream { 
        # render メソッドを使用して、指定された部分テンプレートをレンダリングし、
        # turbo_stream.replace を使って特定のHTML要素('services')を置換します。
        # 'services/services'は_services.html.erb（または同様のテンプレートエンジンを使用している場合は違う拡張子）というファイルを指す。
        render turbo_stream: turbo_stream.replace(
          'services', # これは置換されるHTML要素のIDです。このIDを持つHTML要素が新しい内容で更新されます。
          partial: 'services/services', # 置換に使用される部分テンプレートのパスです。部分テンプレートとは、再利用可能なビューの断片を意味します。
          locals: { services: @services } # これは、部分テンプレートに渡すローカル変数を定義しています。ここでは@servicesというインスタンス変数がテンプレート内で使用されます。
          )
        }
    end
  end


  private

  # サービスのパラメータ
  def service_params
    params.require(:service).permit(:title, :detail, :category_id, :image)
  end

  # 編集・更新・削除用にサービスを設定
  # 特定の Service オブジェクトをロードし、アクセス制御を行うために使用されるメソッドです。
  def set_service
    # user オブジェクトを直接比較する場合、事前にユーザー情報を読み込んでおくことで処理速度が向上します。
    @service = Service.preload(:user).find(params[:id])

    # この条件文は、@service の関連付けられた user が現在ログインしているユーザー (current_user) と同一であるかを確認します。
    # .eql? メソッドは、指定されたユーザーが現在のユーザーと「等しいか」を評価します。ここでの等価はオブジェクトのIDや値が一致することを意味します。
    unless @service.user.eql? current_user
      # and return は、リダイレクト後にさらなる処理を防ぐために使用され、リダイレクトが確実に完了することを保証します。
      redirect_to service_path(@service), notice: 'No tienes autorización' and return
    end
  end
end
