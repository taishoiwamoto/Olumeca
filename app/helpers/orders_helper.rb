# OrdersHelperモジュールの定義。
# このモジュールは、注文に関連するビュー内で利用可能なヘルパーメソッドを集めたものです。

module OrdersHelper
  # 注文の状態コードを受け取り、対応するローカライズされた状態名を返すメソッド。
  # @param status [String] 注文の状態コード
  # @return [String] ローカライズされた注文の状態名
  def get_order_status(status)
    # I18n.tメソッドを使用して、与えられた状態コードに対応するローカライズされた文字列を取得します。
    # "order_statuses.#{status}" は、ローカライズファイル内での状態名のキーを指定しています。
    # 例えば、statusが"pending"であれば、"order_statuses.pending"に対応する値を探します。
    # default: 'Rechazado' は、指定したキーに対応する値が見つからない場合のデフォルト値です。
    # ここでは、状態コードが未知の場合に"Rechazado"（スペイン語で「拒否された」の意）を返します。
    I18n.t("order_statuses.#{status}", default: 'Rechazado')
  end
end
