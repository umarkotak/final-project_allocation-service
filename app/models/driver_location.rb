class DriverLocation < ApplicationRecord

  validates :driver_id, :service_type, :location, :lat, :lng, :status, presence: true
  # validates :driver_id, uniqueness: true
  validates :status, inclusion: { in: %w(online offline busy), message: "%{value} is not a valid status type"  }
  validate :validate_location

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

  private
    def validate_location
      if location != nil && location != ''
        # Setup API keys
        gmaps = GoogleMapsService::Client.new(key: apikey)
        distance_matrix = gmaps.distance_matrix(location, location)
        status = distance_matrix[:rows][0][:elements][0][:status]
        errors.add(:location, "is invalid") if status == "NOT_FOUND"
      end
    end

end
