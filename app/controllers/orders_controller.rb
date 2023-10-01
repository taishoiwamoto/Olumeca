class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @order = Order.new
    @plan = Plan.find_by(id: params[:plan_id])
    @service = @plan.service
    @buyer = current_user
    @seller = User.find(@service.user_id)

    if @seller.id == @buyer.id
      redirect_to @service, notice: 'No puedes comprar tu propio servicio.'
      return
    end
  end

  def create
    @order = Order.new(order_params)

    #if Plan.find(@order.plan_id).deletion_at
    #  redirect_to Plan.find(@order.plan_id).service, notice: 'No se puede realizar el pedido ya que el plan se encuentra cancelado.'
    #  return
    #end

    #if Plan.find(@order.plan_id).service.deletion_at
    #  redirect_to Plan.find(@order.plan_id).service, notice: 'No se puede realizar el pedido ya que el servicio se encuentra cancelado.'
    #  return
    #end


    @order.buyer_id = current_user.id
    @order.buyer_name = current_user.name

    plan = Plan.find(@order.plan_id)

    service = plan.service
    @order.seller_id = service.user_id
    @order.seller_name = User.find(service.user_id).name
    @order.service_title = service.title
    @order.plan_title = plan.title
    @order.price = plan.price
    #@order.status = "pending"
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
    params.require(:order).permit(:plan_id)
  end

  def service_id
    self.plan.service_id
  end
end
