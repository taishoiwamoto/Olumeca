class OrderMailer < ApplicationMailer
  def order_notification
    @order = params[:order]
    @seller = User.find(@order.seller_id)
    mail(to: @seller.email, subject: '¡Se ha realizado un nuevo pedido!')
  end

  def order_status_notificatgition
    @order = params[:order]
    @buyer = User.find(@order.buyer_id)
    @seller = User.find(@order.seller_id)
    subject = if @order.accepted?
                '¡Tu pedido ha sido aceptado!                '
              else
                'Perdón, Tu pedido ha sido rechazado.'
              end
    mail(to: @buyer.email, subject: subject)
  end
end
