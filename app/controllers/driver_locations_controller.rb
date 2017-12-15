class DriverLocationsController < ApplicationController
  def index
    @driver_locations = DriverLocation.all

    render json: @driver_locations
  end
end
