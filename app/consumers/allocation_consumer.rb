class AllocationConsumer < Racecar::Consumer
  subscribes_to "driver_location"

  def process(message)
    data = eval(message.value)

    if data[:action] == 'set_driver_location'
      set_driver_location(data)
    elsif data[:action] == 'unset_driver_location'
      unset_driver_location(data)
    elsif data[:action] == 'get_driver'
      get_driver(data)
    elsif data[:action] == 'set_driver_location_done'
      set_driver_location_done(data)
    end
  end

  def set_driver_location(data)
    @driver_location = DriverLocation.find_by(driver_id: data[:driver_location][:driver_id])
    @driver_location.destroy if @driver_location

    @driver_location = DriverLocation.new(data[:driver_location])
    @driver_location.save
  end

  def unset_driver_location(data)
    @driver_location = DriverLocation.find_by(driver_id: data[:driver_id])
    @driver_location.status = 'offline'
    @driver_location.save
  end

  def get_driver(data)
    driver_locations = DriverLocation.where("status = 'online'")
    driver_locations = driver_locations.where("service_type = '#{data[:service_type]}'")
    driver_locations = select_nearby_driver(data, driver_locations, 20)
    driver_location = driver_locations.sample

    if driver_location
      driver_found(driver_location, data)
    else
      driver_not_found(data)
    end
  end

  def select_nearby_driver(data, driver_locations, max_distance)
    driver_locations.select do |driver_location|
      destination = [driver_location.lat.to_f, driver_location.lng.to_f]
      origin = [data[:origin][:lat], data[:origin][:lng]]
      get_distance(origin, destination) < max_distance
    end
  end

  def driver_found(driver_location, data)
    driver_location.order_id = data[:order_id]
    driver_location.status = 'busy'
    driver_location.save
    send_driver_id_to_application(data[:order_id], driver_location.driver_id)
  end

  def driver_not_found(data)
    sleep(3)
    deliver_message(data, 'driver_location')
  end

  def send_driver_id_to_application(order_id, driver_id)
    data = {}
    data[:action] = 'send_driver_id'
    data[:order_id] = order_id
    data[:driver_id] = driver_id
    deliver_message(data, 'application')
  end

  def set_driver_location_done(data)
    driver_location = DriverLocation.find_by(driver_id: data[:driver_id])
    driver_location.order_id = nil
    driver_location.status = 'online'
    driver_location.save
  end

  def get_distance(loc1, loc2)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    result = rm * c # Delta in meters
    result = result / 1000
  end

  def deliver_message(data, topic)
    kafka = Kafka.new(
      seed_brokers: ['127.0.0.1:9092'],
      client_id: 'goride',
    )
    kafka.deliver_message("#{data}", topic: topic)
  end
end
