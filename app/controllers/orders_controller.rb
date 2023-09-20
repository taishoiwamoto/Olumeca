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
    @order.buyer_id = current_user.id
    service = Plan.find(@order.plan_id).service
    @order.seller_id = service.user_id
    @order.status = "Pendiente"
    if @order.save
      redirect_to completed_orders_path
    else
    end
  end

  def completed
  end

  def show
  end

  private

  def order_params
    params.require(:order).permit(:plan_id)
  end

  def service_id
    self.plan.service_id
  end
end
