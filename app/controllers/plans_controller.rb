class PlansController < ApplicationController

  def show
    @plan = Plan.find(params[:id])
    @service = @plan.service
  end
end
