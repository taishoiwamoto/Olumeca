module ServicesHelper

  def calculate_average_rating(reviews)
    total_rating = reviews.sum { |review| review.rating || 0 }.to_f
    average_rating = total_rating / reviews.size
    average_rating.nan? ? 0 : average_rating.round(2) # こちらを変更します。
  end

  def render_stars(rating)
    "⭐️" * rating.round
  end
end
