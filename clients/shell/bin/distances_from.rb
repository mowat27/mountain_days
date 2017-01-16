#!/usr/bin/env ruby

require 'google_directions'
require 'csv'
require 'open-uri'
require_relative '../lib/travel'
require_relative '../lib/http_client'

include MountainDays

# client = HttpClient.new(base_url: "http://localhost:9292")
client = HttpClient.new(base_url: "http://mountaindays.dev:9292")

journey_origin = HttpClient::Location.new("Buckingham St, Glasgow, G12 8DJ", 55.8776447,-4.288019099999929)
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

client.hills.each do |hill|
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
