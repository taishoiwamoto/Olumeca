# OrdersHelperモジュール: 注文関連のビューヘルパー関数を提供
module OrdersHelper
  # 特定の注文ステータスコードを国際化テキストに変換
  # @param status [String] 注文ステータスを表す文字列
  # @return [String] 国際化された注文ステータスのテキスト
  def get_order_status(status)
    # I18n.tメソッドを使用して、指定されたステータスに対応する翻訳を取得
    # 翻訳が存在しない場合は 'Rechazado'（拒否された）をデフォルト値として返す
    I18n.t("order_statuses.#{status}", default: 'Rechazado')
  end
end
