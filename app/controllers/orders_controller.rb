class OrdersController < ApplicationController
  before_action :authenticate_user, only: [:new, :create]

  def new
    @order = Order.new
    @service = Service.find_by(id: params[:service_id]) # IDをservice_idから取得
    @buyer = @current_user # current_userから@current_userへ変更
    @seller = User.find(@service.user_id)

    if @seller.id == @buyer.id
      redirect_to @service, notice: 'No puedes comprar tu propio servicio.'
      return
    end
  end

  def create
    @order = Order.new(order_params)
    @order.buyer_id = @current_user.id
    @order.seller_id = Service.find(@order.service_id).user_id
    @order.status = "pendiente"
    if @order.save
      redirect_to order_completed_path # ここでorder_completedは購入後のページを指す仮のルートです
    else
      # 失敗した場合の処理
    end
  end

  def completed
  end

  def show
  end

  private

  def order_params
    params.require(:order).permit(:service_id)
  end

  def authenticate_user
    if @current_user.nil?
      redirect_to login_path, notice: 'Por favor, inicia sesión'
    end
  end
end
