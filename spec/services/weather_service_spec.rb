require "rails_helper"

RSpec.describe WeatherService do
  describe "#call" do
    context "when the API returns valid weather data" do
      before do
        stub_request(:get, %r{api\.open-meteo\.com/v1/forecast})
          .to_return(
            status: 200,
            body: {
              current: {
                temperature_2m: 32.5
              },
              daily: {
                temperature_2m_max: [36.0],
                temperature_2m_min: [27.0]
              }
            }.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "returns forecast data" do
        result = described_class.new(
          latitude: 13.08,
          longitude: 80.27
        ).call

        expect(result).to eq(
          {
            current_temp: 32.5,
            high: 36.0,
            low: 27.0
          }
        )
      end
    end

    context "when the API returns invalid data" do
      before do
        stub_request(:get, %r{api\.open-meteo\.com/v1/forecast})
          .to_return(
            status: 200,
            body: {}.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "returns nil" do
        expect(
          described_class.new(
            latitude: 13.08,
            longitude: 80.27
          ).call
        ).to be_nil
      end
    end

    context "when the API returns an error" do
      before do
        stub_request(:get, %r{api\.open-meteo\.com/v1/forecast})
          .to_return(status: 500)
      end

      it "returns nil" do
        expect(
          described_class.new(
            latitude: 13.08,
            longitude: 80.27
          ).call
        ).to be_nil
      end
    end
  end
end
