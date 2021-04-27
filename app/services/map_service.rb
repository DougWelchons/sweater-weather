class MapService

  def self.get_geocode(address)
    response = make_api_call("/geocoding/v1/address?key=#{ENV['MQ-KEY']}&location=#{address}")
    OpenStruct.new({
                     lat: response[:results].first[:locations].first[:latLng][:lat],
                     lng: response[:results].first[:locations].first[:latLng][:lng]
                    })
  end

  def self.get_route(from, to)
    response = make_api_call("/directions/v2/route?key=#{ENV['MQ-KEY']}&from=#{from}&to=#{to}")
    # require "pry"; binding.pry
    return OpenStruct.new({travel_time: "impossible"}) if response[:route][:routeError][:errorCode] == 2
     hours = response[:route][:realTime] / 3600
     minutes = response[:route][:realTime] % 3600 / 60
     OpenStruct.new({travel_time: "#{hours} hours, #{minutes} minutes"})
  end

  def self.make_api_call(url)
    response = connection.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['MQ-GEOCODE-API'])
  end
end
