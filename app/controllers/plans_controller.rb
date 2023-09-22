class PlansController < ApplicationController
  before_action :setup_service

  def show
    @plan = Plan.find(params[:id])
    @service = @plan.service
  end

  def new; end

  def destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("plan_#{params[:index]}") }
    end
  end

  private

  def setup_service
    @service = Service.new(plans: [Plan.new])
  end
end
