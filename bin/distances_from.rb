#!/usr/bin/env ruby

require 'google_directions'
require 'csv'
require 'open-uri'
require_relative '../lib/mountain_days'
require_relative '../lib/google_driving_distances'
require_relative '../lib/hill'

include MountainDays

PROJECT_ROOT = File.expand_path("#{File.dirname($PROGRAM_NAME)}/..")

home = [55.8776447, -4.288019099999929]
peaks = load_peaks(File.expand_path("#{PROJECT_ROOT}/munros.csv"))


headers = %w(
    hillname
    direct_distance_in_miles
    road_distance_in_miles
    drive_time_in_minutes
    metres
    feet
    gridref
    latitude
    longitude
)

CSV($stdout) { |out| out << headers }

distances_from_lat_long(peaks, home).
    # take(1).
    map     { |hash| Hill.new(hash).
                      add_direct_distance.
                      add_road_distances_and_times(sleep_when: ->(hill) {hill.hillnumber.to_i > 0 && hill.hillnumber.to_i % 49 == 0}) }.
    sort_by { |hill| hill.to_hash["direct_distance_in_miles"].to_i }.
    each    { |hill| CSV($stdout) {|out| out << hill.select_columns(headers)} }
