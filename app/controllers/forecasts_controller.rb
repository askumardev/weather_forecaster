class ForecastsController < ApplicationController
  def new
  end

  def create
    if params[:address].blank?
      flash.now[:notice] = "Please enter an address."
      render :new
    end

  end
end
