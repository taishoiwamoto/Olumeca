class OrdersController < ApplicationController
  # 認証されたユーザーのみにアクセスを許可するアクションを指定
  before_action :authenticate_user, only: [:new, :create, :completed, :accept, :reject]
  # 新しい注文を作成する前に、既に同じサービスに対する注文が存在するかをチェック
  before_action :check_order_existence, only: [:new, :create]
  # 自身のサービスを購入しようとするのを防止
  before_action :prevent_purchase_of_own_service, only: [:new, :create]

  # 新しい注文のページ
  # includes(:user) は、Service レコードをデータベースから取得する際に、関連する User レコードも同時にロードすることを指示します。
  # purchased_orders: これは User モデルに定義されている has_many 関連を表します。つまり、一人のユーザーが複数の注文（Order レコード）を持つことができるという関係です。
  # .build(): build メソッドは、関連オブジェクトの新しいインスタンスをメモリ上に作成しますが、データベースには保存しません。この新しい注文オブジェクトは @order インスタンス変数に保存され、通常、フォームで使用してユーザーに情報入力を促します。
  def new
    # 総処理時間が短く、データベースのクエリ時間も少なく、メモリ割り当ても少ないため、サーバーのリソースをより効率的な使用、を確認
    @service = Service.includes(:user).find(params[:service_id])
    @order = current_user.purchased_orders.build()
  end

  # 注文を作成し、保存する
  # includes(:user) は、Service レコードをデータベースから取得する際に、関連する User レコードも同時にロードすることを指示します。
  # purchased_orders: これは User モデルに定義されている has_many 関連を表します。つまり、一人のユーザーが複数の注文（Order レコード）を持つことができるという関係です。
  # .build(): build メソッドは、関連オブジェクトの新しいインスタンスをメモリ上に作成しますが、データベースには保存しません。この新しい注文オブジェクトは @order インスタンス変数に保存され、通常、フォームで使用してユーザーに情報入力を促します。
  def create
    @service = Service.find(params[:order][:service_id])
    @order = current_user.purchased_orders.build(
      service_id: @service.id,
      seller_id: @service.user_id
    )

    if @order.save
      # with メソッドは、メーラーに引数として情報を渡すために使用されます。この場合、order: @order という形で @order インスタンス（注文情報）をメーラーに渡しています。これにより、メールのテンプレート内で @order のデータを利用して、注文の詳細をメール本文に含めることができます。
      OrderMailer.with(order: @order).order_notification.deliver_later
      redirect_to completed_orders_path
    else
      flash.now[:alert] = 'Hubo un error al crear el pedido. Por favor, inténtalo de nuevo.'
      render :new
    end
  end

  # 注文が完了したことを示すページ
  def completed
  end

  # 特定の注文を表示
  def show
  end

  # 注文を受け入れる
  def accept
    #Order.includes(service: :user).find(params[:id])：この部分で、データベースから特定のIDを持つOrderオブジェクトを検索しています。includes(service: :user)はEager Loadingを使って、関連するserviceオブジェクトとそのuserオブジェクトを一緒に前もってロードすることで、後の処理で発生する可能性のあるN+1クエリ問題を防ぎます。
    @order = Order.includes(service: :user).find(params[:id])
    # accepted! は Order モデルに定義された状態遷移メソッドの一つで、enumを用いて注文のステータスを「受け付け済み」に変更しています。
    @order.accepted!
    # OrderMailer.with(order: @order).order_status_notification.deliver_later：これにより、注文のステータス更新をユーザーに通知するメールが、非同期的に（バックグラウンドジョブを使って）送信されます。
    OrderMailer.with(order: @order).order_status_notification.deliver_later
    redirect_to sales_user_path(current_user.id), notice: 'Pedido aceptado.'
  end

  # 注文を拒否する
  def reject
    #Order.includes(service: :user).find(params[:id])：この部分で、データベースから特定のIDを持つOrderオブジェクトを検索しています。includes(service: :user)はEager Loadingを使って、関連するserviceオブジェクトとそのuserオブジェクトを一緒に前もってロードすることで、後の処理で発生する可能性のあるN+1クエリ問題を防ぎます。
    @order = Order.includes(service: :user).find(params[:id])
    # rejected! は Order モデルに定義された状態遷移メソッドの一つで、enumを用いて注文のステータスを「拒否済み」に変更しています。
    @order.rejected!
    # OrderMailer.with(order: @order).order_status_notification.deliver_later：これにより、注文のステータス更新をユーザーに通知するメールが、非同期的に（バックグラウンドジョブを使って）送信されます。
    OrderMailer.with(order: @order).order_status_notification.deliver_later
    redirect_to sales_user_path(current_user.id), notice: 'Pedido rechazado.'
  end

  # ユーザー情報を表示するページ
  #def user_info
  #  @user = User.find(params[:user_id])
  #end

  private

  # 注文の存在をチェックし、既に存在する場合は警告とともにリダイレクト
  def check_order_existence
    # params[:action] == "new" ? params[:service_id] : params[:order][:service_id]：三項演算子を使用して条件分岐を行っています。
    # もし現在のアクションが "new" であれば params[:service_id] を使用し、そうでなければ params[:order][:service_id] を使用します。
    # これは、新規作成画面と編集画面など、異なるコンテキストでこのメソッドが呼び出される場合、適切なサービスIDを取得するためです。
    @service = Service.find(params[:action] == "new" ? params[:service_id] : params[:order][:service_id])
    if Order.exists?(buyer: current_user, service: @service)
      redirect_to @service, alert: 'Ya has pedido este servicio.'
    end
  end

  # 自分のサービスを購入することを防止し、警告とともにリダイレクト
  def prevent_purchase_of_own_service
    # params[:action] == "new" ? params[:service_id] : params[:order][:service_id]：三項演算子を使用して条件分岐を行っています。
    # もし現在のアクションが "new" であれば params[:service_id] を使用し、そうでなければ params[:order][:service_id] を使用します。
    # これは、新規作成画面と編集画面など、異なるコンテキストでこのメソッドが呼び出される場合、適切なサービスIDを取得するためです。
    @service = Service.find(params[:action] == "new" ? params[:service_id] : params[:order][:service_id])
    if @service.user_id == current_user.id
      redirect_to @service, alert: 'No puedes pedir tu propio servicio.'
    end
  end
end
