# OrderMailerクラスはApplicationMailerを継承しています。
# このクラスは注文に関連するメールを送信するためのメソッドを定義しています。
class OrderMailer < ApplicationMailer
  # 注文が行われたときに出品者に通知するメールを送信します。
  def order_notification
    # メールで必要な注文情報を@orderにセットします。
    @order = params[:order]
    # 注文を行った出品者の情報を@sellerにセットします。
    @seller = User.find(@order.seller_id)
    # 出品者に向けてメールを送信します。
    # to: 送信先のメールアドレス、subject: メールの件名
    mail(to: @seller.email, subject: '¡Se ha realizado un nuevo pedido!', from: 'Olumeca <contact@lecmarket.com>')
  end

  # 注文のステータス更新（承認・拒否）を購入者に通知するメールを送信します。
  def order_status_notification
    # 注文情報を@orderにセットします。
    @order = params[:order]
    # 注文の購入者情報を@buyerにセットします。
    @buyer = User.find(@order.buyer_id)
    # 注文の出品者情報を@sellerにセットします。
    @seller = User.find(@order.seller_id)
    # 注文が承認されたかどうかで件名を変更します。
    subject = if @order.accepted?
                '¡Tu pedido ha sido aceptado!                '
              else
                'Perdón, Tu pedido ha sido rechazado.'
              end
    # 購入者に向けてメールを送信します。
    mail(to: @buyer.email, subject: subject, from: 'Olumeca <contact@lecmarket.com>')
  end
end
