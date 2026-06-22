class ForecastsController < ApplicationController
  def new
  end

  def create
    if address.blank?
      flash.now[:alert] = "Please enter an address."
      render :new
      return
    end
    result = GeocodingService.new(address).call

    if result.present?
      flash[:notice] = "Location found for #{result[:city]}"
    else
      flash[:alert] = "Unable to find the provided address."
    end

    redirect_to root_path

  end

  private

  def address
    params[:address]
  end
end
