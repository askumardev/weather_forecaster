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

    context "when location is found" do
      let(:service) { instance_double(GeocodingService) }

      before do
        allow(GeocodingService)
          .to receive(:new)
          .with("Chennai, India")
          .and_return(service)

        allow(service)
          .to receive(:call)
          .and_return(
            {
              lat: 13.08,
              lng: 80.27,
              zip: "600001",
              city: "Chennai"
            }
          )
      end

      it "redirects to root with success message" do
        post forecasts_path, params: { address: "Chennai, India" }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Location found for Chennai")
      end
    end

    context "when location is not found" do
      let(:service) { instance_double(GeocodingService) }

      before do
        allow(GeocodingService)
          .to receive(:new)
          .with("Invalid Address")
          .and_return(service)

        allow(service)
          .to receive(:call)
          .and_return(nil)
      end

      it "redirects to root with error message" do
        post forecasts_path, params: { address: "Invalid Address" }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Unable to find the provided address.")
      end
    end
  end
end
