class HomeController < ApplicationController
  before_action :forbid_login_user, except: [:top]

  def top
    @services = Service.order(created_at: :desc).limit(4)
  end

  def about
  end
end
