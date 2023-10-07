class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @order = Order.new
    @buyer = current_user
    @seller = User.find(@service.user_id)

    if @seller.id == @buyer.id
      redirect_to @service, notice: 'No puedes pedir tu propio servicio.'
      return
    end
  end

  def create
    @order = Order.new(order_params)

    @order.buyer_id = current_user.id
    @order.buyer_name = current_user.name

    @order.seller_id = service.user_id
    @order.seller_name = User.find(service.user_id).name
    @order.service_title = service.title
    if @order.save
      OrderMailer.with(order: @order).order_notification.deliver_later
      redirect_to completed_orders_path
    else
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
end
