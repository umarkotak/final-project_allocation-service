# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

DriverLocation.create!(
  driver_id: 1,
  service_type: 'gojek',
  order_id: nil,
  location: 'kemang',
  lat: -6.2622689,
  lng: 106.8134181,
  status: 'online'
)

DriverLocation.create!(
  driver_id: 2,
  service_type: 'gojek',
  order_id: nil,
  location: 'jakarta',
  lat: -6.17511,
  lng: 106.8650395,
  status: 'online'
)

DriverLocation.create!(
  driver_id: 3,
  service_type: 'gojek',
  order_id: nil,
  location: 'jakarta',
  lat: -6.17511,
  lng: 106.8650395,
  status: 'online'
)

DriverLocation.create!(
  driver_id: 4,
  service_type: 'gocar',
  order_id: nil,
  location: 'jakarta',
  lat: -6.17511,
  lng: 106.8650395,
  status: 'online'
)