class AllocationConsumer < Racecar::Consumer
  subscribes_to "driver_location"

  def process(message)
    data = eval(message.value)

    if data[:action] == 'set_driver_location'
      set_driver_location(data)
      puts "========================="
      puts "DATA = #{data}"
      puts "========================="
    end
  end

  def set_driver_location(data)
    @driver_location = DriverLocation.find_by(driver_id: data[:driver_location][:driver_id])
    @driver_location.destroy if @driver_location

    @driver_location = DriverLocation.new(data[:driver_location])
    @driver_location.save
  end
end
