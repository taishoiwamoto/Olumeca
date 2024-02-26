class HomeController < ApplicationController
  def top
    @services = Service.active.order(created_at: :desc).limit(4)
  end
end
