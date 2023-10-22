module ServicesHelper
  def render_stars(rating)
    "⭐️" * rating.round
  end
end
