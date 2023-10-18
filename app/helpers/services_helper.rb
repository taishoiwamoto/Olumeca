module ServicesHelper

  # [重要度: 中] 平均を求める処理が、モデルとhelperに分散しています。モデルへの集約を検討してください。→ 完了

  def render_stars(rating)
    "⭐️" * rating.round
  end
end
