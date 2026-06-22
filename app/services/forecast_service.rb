class ForecastService
  CACHE_EXPIRATION = 30.minutes

  def initialize(address)
    @address = address
  end

  def call
    location = GeocodingService.new(address).call
    return nil unless location

    cache_key = build_cache_key(location)
    from_cache = Rails.cache.exist?(cache_key)

    forecast = Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRATION) do
      WeatherService.new(
        latitude: location[:lat],
        longitude: location[:lng]
      ).call
    end

    return nil unless forecast

    forecast.merge(
      city: location[:city],
      zip: location[:zip],
      from_cache: from_cache
    )
  end

  private

  attr_reader :address

  def build_cache_key(location)
    if location[:zip].present?
      "forecast:#{location[:zip]}"
    else
      "forecast:#{location[:lat]}:#{location[:lng]}"
    end
  end
end
