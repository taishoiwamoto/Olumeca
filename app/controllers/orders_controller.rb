class OrdersController < ApplicationController
  # 認証されたユーザーのみにアクセスを許可するアクションを指定
  before_action :authenticate_user, only: [:new, :create, :completed, :accept, :reject, :user_info]
  # 新しい注文を作成する前に、既に同じサービスに対する注文が存在するかをチェック
  before_action :check_order_existence, only: [:new, :create]
  # 自身のサービスを購入しようとするのを防止
  before_action :prevent_purchase_of_own_service, only: [:new, :create]

  # 新しい注文のページ
  def new
    @service = Service.includes(:user).find(params[:service_id])
    @order = current_user.purchased_orders.build()
  end

  # 注文を作成し、保存する
  def create
    @service = Service.includes(:user).find(params[:order][:service_id])
    @order = current_user.purchased_orders.build(
      service_id: @service.id,
      seller_id: @service.user_id
    )

    if @order.save
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
    @order = Order.includes(service: :user).find(params[:id])
    @order.accepted!
    OrderMailer.with(order: @order).order_status_notification.deliver_later
    redirect_to sales_user_path(current_user.id), notice: 'Pedido aceptado.'
  end

  # 注文を拒否する
  def reject
    @order = Order.includes(service: :user).find(params[:id])
    @order.rejected!
    OrderMailer.with(order: @order).order_status_notification.deliver_later
    redirect_to sales_user_path(current_user.id), notice: 'Pedido rechazado.'
  end

  # ユーザー情報を表示するページ
  def user_info
    @user = User.find(params[:user_id])
  end

  private

  # 注文の存在をチェックし、既に存在する場合は警告とともにリダイレクト
  def check_order_existence
    @service = Service.find(params[:action] == "new" ? params[:service_id] : params[:order][:service_id])
    if Order.exists?(buyer: current_user, service: @service)
      redirect_to @service, alert: 'Ya has pedido este servicio.'
    end
  end

  # 自分のサービスを購入することを防止し、警告とともにリダイレクト
  def prevent_purchase_of_own_service
    @service = Service.find(params[:action] == "new" ? params[:service_id] : params[:order][:service_id])
    if @service.user_id == current_user.id
      redirect_to @service, alert: 'No puedes pedir tu propio servicio.'
    end
  end
end
