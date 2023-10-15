class HomeController < ApplicationController
  before_action :forbid_login_user, except: [:top]

  def top
    # [重要度: 低] Serviceの量が増えてきたときに動作が遅くなる可能性があります。DBに適切なインデックスを張ることをお勧めします。
    @services = Service.active.order(created_at: :desc).limit(4)
  end
end
