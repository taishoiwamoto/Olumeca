class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @service = Service.find(params[:service_id])
    @order = current_user.purchased_orders.build(service_title: @service.title)
  end

  def create
    @service = Service.find(params[:order][:service_id])
    @order = current_user.purchased_orders.build(
      service_id: @service.id,
      service_title: @service.title,
      seller_id: @service.user.id,
      seller_name: @service.user.name,
      buyer_name: current_user.name,
    )

    if @order.save
      OrderMailer.with(order: @order).order_notification.deliver_later
      redirect_to completed_orders_path
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

  def order_params
    params.require(:order).permit(:service_id)
  end
end
