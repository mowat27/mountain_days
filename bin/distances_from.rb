#!/usr/bin/env ruby

require 'google_directions'
require 'csv'
require 'open-uri'
require_relative '../lib/mountain_days'

include MountainDays

read_model = ReadModel.hydrate(
  hills: App::FILES.munros,
  locations: App::FILES.locations,
  starting_points: App::FILES.starting_points,
)

journey_origin = Location.new("Buckingham St, Glasgow, G12 8DJ", 55.8776447,-4.288019099999929)
compute_road_distances = false

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
  by_road = compute_road_distances ? Journeys::road_journey(journey_origin, drive_to) : Journeys::not_computed

  CSV($stdout) {|out| out << [
    hill.name,
    journey_origin.name,
    journey_origin.latitude,
    journey_origin.longitude,
    drive_to.name,
    drive_to.latitude,
    drive_to.longitude,
    Journeys::direct_distance(journey_origin, drive_to).to_miles.round,
    by_road.distance.to_miles.round,
    by_road.status
  ]}
end
