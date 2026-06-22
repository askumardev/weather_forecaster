class ForecastsController < ApplicationController
  def new
  end

  def create
    if address.blank?
      flash.now[:alert] = "Please enter an address."
      return render :new
    end

    @forecast = ForecastService.new(address).call

    if @forecast.present?
      @address = address
      render :new
    else
      flash[:alert] = "Unable to retrieve forecast."
      redirect_to root_path
    end
  end

  private

  def address
    params[:address]
  end
end
