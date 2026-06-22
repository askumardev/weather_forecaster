require "rails_helper"

RSpec.describe GeocodingService do
  describe "#call" do
    context "when API returns a location" do
      before do
        stub_request(:get, %r{nominatim\.openstreetmap\.org/search})
          .to_return(
            status: 200,
            body: [
              {
                lat: "13.08",
                lon: "80.27",
                address: {
                  postcode: "600001",
                  city: "Chennai"
                }
              }
            ].to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "returns coordinates and location details" do
        result = described_class.new("Chennai, India").call

        expect(result).to eq(
          {
            lat: 13.08,
            lng: 80.27,
            zip: "600001",
            city: "Chennai"
          }
        )
      end
    end

    context "when API returns no results" do
      before do
        stub_request(:get, %r{nominatim\.openstreetmap\.org/search})
          .to_return(
            status: 200,
            body: [].to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "returns nil" do
        expect(described_class.new("Invalid Address").call).to be_nil
      end
    end
  end
end
