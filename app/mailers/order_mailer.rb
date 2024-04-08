class OrderMailer < ApplicationMailer
  # 注文が行われた際に出品者に通知するメールを送信するメソッド
  def order_notification
    # メソッド呼び出し時に渡されたパラメータから注文情報を取得
    @order = params[:order]
    # 注文情報から出品者のユーザー情報を取得
    @seller = User.find(@order.seller_id)
    # 出品者にメールを送信。件名は「¡Se ha realizado un nuevo pedido!」で、送信元は'Olumeca <contact@lecmarket.com>'
    mail(to: @seller.email, subject: '¡Se ha realizado un nuevo pedido!', from: 'Olumeca <contact@lecmarket.com>')
  end

  # 注文の状態更新（承認または拒否）時に購入者に通知するメールを送信するメソッド
  def order_status_notification
    # メソッド呼び出し時に渡されたパラメータから注文情報を取得
    @order = params[:order]
    # 注文情報から購入者のユーザー情報を取得
    @buyer = User.find(@order.buyer_id)
    # 注文情報から出品者のユーザー情報も取得
    @seller = User.find(@order.seller_id)

    # 注文が承認されたかどうかによってメールの件名を変更
    subject = if @order.accepted?
                '¡Tu pedido ha sido aceptado!'
              else
                'Perdón, Tu pedido ha sido rechazado.'
              end
    # 購入者にメールを送信。件名は注文の状態によって変わり、送信元は'Olumeca <contact@lecmarket.com>'
    mail(to: @buyer.email, subject: subject, from: 'Olumeca <contact@lecmarket.com>')
  end
end
