# ServicesHelperモジュールの定義。
# このモジュールは、サービス関連のビューで利用するヘルパーメソッドを集めたものです。
module ServicesHelper
  # 与えられた評価を基に、対応する数の星の絵文字を文字列として返すメソッド。
  # @param rating [Numeric] 評価（0から5などの数値範囲を想定）
  # @return [String] 評価に応じた星の絵文字を繰り返した文字列
  def render_stars(rating)
    # `rating.round`で評価を最も近い整数に丸め、
    # その数だけ星の絵文字（`⭐️`）を繰り返しています。
    # 例えば、評価が3.5の場合は4に丸められ、4つの星が返されます。
    "⭐️" * rating.round
  end
end
