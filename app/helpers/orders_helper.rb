# OrdersHelperモジュール: 注文関連のビューヘルパー関数を提供
module OrdersHelper
  def get_order_status(status)
    # 注文ステータスの国際化: この関数は、注文のステータスコード（'pending'、'accepted'、'rejected' など）を引数として受け取り、それをアプリケーションで使用される言語に適した形で表示するためのテキストに変換します。
    # 翻訳が存在しない場合は 'Rechazado'（拒否された）をデフォルト値として返す
    I18n.t("order_statuses.#{status}", default: 'Rechazado')
  end
end
