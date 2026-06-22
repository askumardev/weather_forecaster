require "rails_helper"

RSpec.describe "Forecasts", type: :request do
  describe "GET /" do
    it "renders the forecast page successfully" do
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /forecasts" do
    context "when address is blank" do
      it "renders the form with validation message" do
        post forecasts_path, params: { address: "" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Please enter an address.")
      end
    end

    context "when forecast is successfully retrieved" do
      let(:forecast_service) { instance_double(ForecastService) }

      before do
        allow(ForecastService)
          .to receive(:new)
          .with("Chennai, India")
          .and_return(forecast_service)

        allow(forecast_service)
          .to receive(:call)
          .and_return(
            {
              current_temp: 32.5,
              high: 36.0,
              low: 27.0,
              city: "Chennai",
              zip: "600001",
              from_cache: false
            }
          )
      end

      it "renders forecast information" do
        post forecasts_path, params: { address: "Chennai, India" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Current Temp")
      end
    end

    context "when forecast retrieval fails" do
      let(:forecast_service) { instance_double(ForecastService) }

      before do
        allow(ForecastService)
          .to receive(:new)
          .with("Invalid Address")
          .and_return(forecast_service)

        allow(forecast_service)
          .to receive(:call)
          .and_return(nil)
      end

      it "redirects with an error message" do
        post forecasts_path, params: { address: "Invalid Address" }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Unable to retrieve forecast.")
      end
    end
  end
end
