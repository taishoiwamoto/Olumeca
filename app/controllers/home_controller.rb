class HomeController < ApplicationController
  before_action :forbid_login_user, except: [:top]

  def top
    @services = Service.active.order(created_at: :desc).limit(5)
  end
end
