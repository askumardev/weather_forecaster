
class WeatherService
  include HTTParty

  base_uri "https://api.open-meteo.com"

  def initialize(latitude:, longitude:)
    @latitude = latitude
    @longitude = longitude
  end

  def call
    response = fetch_forecast

    return nil unless valid_response?(response)

    build_result(response.parsed_response)
  rescue StandardError => e
    Rails.logger.error("[WeatherService] #{e.class}: #{e.message}")
    nil
  end

  private

  attr_reader :latitude, :longitude

  def fetch_forecast
    self.class.get(
      "/v1/forecast",
      query: query_params
    )
  end

  def query_params
    {
      latitude: latitude,
      longitude: longitude,
      current: "temperature_2m",
      daily: "temperature_2m_max,temperature_2m_min",
      forecast_days: 1,
      timezone: "auto"
    }
  end

  def valid_response?(response)
    response.success? &&
      response.parsed_response.present? &&
      response.parsed_response["current"].present?
  end

  def build_result(result)
    {
      current_temp: result.dig("current", "temperature_2m"),
      high: result.dig("daily", "temperature_2m_max")&.first,
      low: result.dig("daily", "temperature_2m_min")&.first
    }
  end
end
