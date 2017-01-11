#!/usr/bin/env ruby

require 'google_directions'
require 'csv'
require 'open-uri'
require_relative '../lib/mountain_days'
require_relative '../lib/google_driving_distances'
require_relative '../lib/hill'
require_relative '../lib/hills/read_model'

PROJECT_ROOT = File.expand_path("#{File.dirname($PROGRAM_NAME)}/..")
home = Hills::Location.new("Buckingham St, Glasgow, G12 8DJ", 55.8776447,-4.288019099999929)

include MountainDays

hills = load_csv(File.expand_path("#{PROJECT_ROOT}/data/munros.csv"))
starting_points = load_csv(File.expand_path("#{PROJECT_ROOT}/data/starting_points.csv"))

read_model = Hills::ReadModel.new

hills.each do |peak|
  read_model.load_event(:new_munro_added, hillnumber: peak["hillnumber"], name: peak["hillname"])
  read_model.load_event(:summit_added, hillnumber: peak["hillnumber"], latitude: peak["latitude"], longitude: peak["longitude"])
end

starting_points.each do |starting_point|
  read_model.load_event(:starting_point_added, hillnumber: starting_point["hillnumber"], name: "start", latitude: starting_point["latitude"], longitude: starting_point["longitude"])
end

CSV($stdout) { |out| out << %w(
    hillname
    origin_name
    origin_latitude
    origin_longitude
    destination_name
    destination_latitude
    destination_longitude
    direct_distance
    road_distance
    google_status
) }
read_model.hills.each do |hill|
  drive_to = hill.best_guess_driving_destination
  by_road = Journeys::road_journey(home, drive_to)

  CSV($stdout) {|out| out << [
    hill.name,
    home.name,
    home.latitude,
    home.longitude,
    drive_to.name,
    drive_to.latitude,
    drive_to.longitude,
    Journeys::direct_distance(home, drive_to).to_miles.round,
    by_road.distance.to_miles.round,
    by_road.status
  ]}
end
