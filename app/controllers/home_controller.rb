class HomeController < ApplicationController
  def top
    # [重要度: 低] Serviceの量が増えてきたときに動作が遅くなる可能性があります。DBに適切なインデックスを張ることをお勧めします。→ 完了
    @services = Service.active.order(created_at: :desc).limit(4)
  end
end
