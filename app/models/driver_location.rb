class DriverLocation < ApplicationRecord

  validates :driver_id, :service_type, :location, :lat, :lng, :status, presence: true
  validates :status, inclusion: { in: %w(online offline busy), message: "%{value} is not a valid status type"  }

  def apikey
    "AIzaSyAxXs-AipMveHRNInl7P3HubboAWgK4aqU"
  end

  def get_coordinate(location_name)
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location_name}+&key=#{apikey}"
    request = HTTP.get(url).to_s
    request = JSON.parse(request)
    self.lat = request["results"][0]["geometry"]["location"]["lat"]
    self.lng = request["results"][0]["geometry"]["location"]["lng"]
  end
end
