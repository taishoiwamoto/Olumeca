class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @order = Order.new
    @buyer = current_user
    @service = Service.find(params["service_id"])
    @seller = User.find(@service.user_id)

    if @seller.id == @buyer.id
      redirect_to @service, notice: 'No puedes pedir tu propio servicio.'
      return
    end
  end

  def create
    begin
      @order = Order.new(order_params)
      @order.buyer_id = current_user.id
      @order.buyer_name = current_user.name
      @order.seller_id = @order.service.user_id
      @order.seller_name = User.find(@order.service.user_id).name
      @order.service_title = @order.service.title
    rescue => error
      p 'Ocurrió un error'
      p error.message
    end
    
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

  private

  def order_params
    params.require(:order).permit(:service_id)
  end  
end
