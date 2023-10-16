class OrdersController < ApplicationController
  # [重要度: 高] accept, rejectはユーザログインを求めなくてもよいのでしょうか？
  before_action :authenticate_user, only: [:new, :create, :completed]
  before_action :check_order_existence, only: [:new, :create]
  before_action :prevent_purchase_of_own_service, only: [:new, :create]

  def new
    @service = Service.find(params[:service_id])
    @order = current_user.purchased_orders.build()
  end

  def create
    @service = Service.find(params[:order][:service_id])
    @order = current_user.purchased_orders.build(
      service_id: @service.id,
      # [重要度: 低] @service.user.id -> @service.user_id としてください。usersテーブルへのSELECTを減らし、より高速な動作が見込めます
      seller_id: @service.user.id
    )

    if @order.save
      OrderMailer.with(order: @order).order_notification.deliver_later
      redirect_to completed_orders_path
    else
      # [重要度: 中] エラー発生時の処理が抜けてます
    end
  end

  def completed
  end

  def show
  end

  def accept
    @order = Order.find(params[:id])
    @order.accepted!
    OrderMailer.with(order: @order).order_status_notification.deliver_later
    redirect_to sales_user_path(current_user.id), notice: 'Pedido aceptado.'
  end

  def reject
    @order = Order.find(params[:id])
    @order.rejected!
    OrderMailer.with(order: @order).order_status_notification.deliver_later
    redirect_to sales_user_path(current_user.id), notice: 'Pedido rechazado.'
  end

  def user_info
    @user = User.find(params[:user_id])
  end

  private

  # [重要度: 低] 利用されていないメソッド
  def order_params
    params.require(:order).permit(:service_id)
  end

  def check_order_existence
    # [重要度: 高] params[:order][:service_id]が不適切な値でも、params[:service_id]に適切な値を入れると注文することが可能になります
    @service = Service.find(params[:service_id] || params[:order][:service_id])
    if Order.exists?(buyer: current_user, service: @service)
      redirect_to @service, alert: 'Ya has pedido este servicio.'
    end
  end

  def prevent_purchase_of_own_service
    # [重要度: 高] params[:order][:service_id]が不適切な値でも、params[:service_id]に適切な値を入れると注文することが可能になります
    @service = Service.find(params[:service_id] || params[:order][:service_id])
    # [重要度: 低] @service.user_id == current_user.idとしたほうが、userテーブルへのselectが走らず、より高速な動作が可能です
    if @service.user == current_user
      redirect_to @service, alert: 'No puedes pedir tu propio servicio.'
    end
  end
end
