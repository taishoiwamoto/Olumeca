class OrdersController < ApplicationController
  before_action :authenticate_user, only: [:new, :create, :completed, :accept, :reject, :user_info]
  before_action :check_order_existence, only: [:new, :create]
  before_action :prevent_purchase_of_own_service, only: [:new, :create]

  def new
    @service = Service.includes(:user).find(params[:service_id])
    @order = current_user.purchased_orders.build()
  end

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

  def completed
  end

  def show
  end

  def accept
    @order = Order.includes(service: :user).find(params[:id])
    @order.accepted!
    OrderMailer.with(order: @order).order_status_notification.deliver_later
    redirect_to sales_user_path(current_user.id), notice: 'Pedido aceptado.'
  end

  def reject
    @order = Order.includes(service: :user).find(params[:id])
    @order.rejected!
    OrderMailer.with(order: @order).order_status_notification.deliver_later
    redirect_to sales_user_path(current_user.id), notice: 'Pedido rechazado.'
  end

  def user_info
    @user = User.find(params[:user_id])
  end

  private

  def check_order_existence
    @service = Service.find(params[:action] == "new" ? params[:service_id] : params[:order][:service_id])
    if Order.exists?(buyer: current_user, service: @service)
      redirect_to @service, alert: 'Ya has pedido este servicio.'
    end
  end

  def prevent_purchase_of_own_service
    @service = Service.find(params[:action] == "new" ? params[:service_id] : params[:order][:service_id])
    if @service.user_id == current_user.id
      redirect_to @service, alert: 'No puedes pedir tu propio servicio.'
    end
  end
end
