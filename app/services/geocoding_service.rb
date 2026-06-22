class GeocodingService
  include HTTParty

  base_uri "https://nominatim.openstreetmap.org"

  def initialize(address)
    @address = address.to_s.strip
  end

  def call
    return nil unless valid_address?

    response = fetch_location

    return nil unless valid_response?(response)

    build_result(response.parsed_response.first)
  rescue StandardError => e
    Rails.logger.error("[GeocodingService] #{e.class}: #{e.message}")
    nil
  end

  private

  attr_reader :address

  def fetch_location
    self.class.get(
      "/search",
      query: query_params,
      headers: request_headers
    )
  end

  def query_params
    {
      q: address,
      format: "json",
      addressdetails: 1,
      limit: 1
    }
  end

  def request_headers
    {
      "User-Agent" => "WeatherForecaster/1.0"
    }
  end

  def valid_response?(response)
    response.success? && response.parsed_response.present?
  end

  def build_result(result)
    address_data = result["address"] || {}

    {
      lat: result["lat"].to_f,
      lng: result["lon"].to_f,
      zip: address_data["postcode"],
      city: city_from(address_data)
    }
  end

  def city_from(address_data)
    address_data["city"] ||
      address_data["town"] ||
      address_data["village"] ||
      address_data["state_district"]
  end

  def valid_address?
    address.match?(/\A\d{5,6}\z/) || address.include?(" ")
  end
end
