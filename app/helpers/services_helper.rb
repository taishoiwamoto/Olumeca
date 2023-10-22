module ServicesHelper

  #完了 [重要度: 中] 平均を求める処理が、モデルとhelperに分散しています。モデルへの集約を検討してください。

  def render_stars(rating)
    "⭐️" * rating.round
  end
end
