# ServicesHelperモジュール: サービス関連のビューヘルパー関数を提供
module ServicesHelper
  # 与えられた評価を星のアイコンで表現するためのメソッド
  # @param rating [Integer, Float] 評価スコア（通常1から5の範囲）
  # @return [String] 評価スコアに対応する星のアイコン文字列
  def render_stars(rating)
    # ratingを四捨五入し、その数だけ星のアイコンを連結して生成
    "⭐️" * rating.round
  end
end
