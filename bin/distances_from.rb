#!/usr/bin/env ruby

require 'google_directions'
require 'csv'
require 'open-uri'
require_relative '../lib/mountain_days'
require_relative '../lib/google_driving_distances'

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

class Hill
    include MountainDays::RoadDistances

    def initialize(hill)
        @hill = hill.to_hash
        @hill.keys.each do |key|
          define_singleton_method(key) { self[key] }
        end
    end

    def to_hash
        @hill.clone
    end

    def [](key)
      @hill[key]
    end

    def select_columns(headers)
      headers.reduce([]) { |memo, header| memo << self[header] }
    end

    def add_road_distances_and_times(sleep_when: ->(hill) {false}, sleep_for: 1)
        sleep(sleep_for) if sleep_when.call(self)

        journey = journey open(url(from_lat_long, to_lat_long)).read
        STDERR.puts(hillname + ": " + journey.status) if !journey.valid?

        Hill.new(@hill.merge('road_distance_in_miles' => journey.distance_in_metres,
                             'drive_time_in_minutes' => journey.duration_in_seconds))
    end

    def add_direct_distance
      Hill.new(@hill.merge('direct_distance_in_miles' => distance.to_miles.round))
    end

    private
    def as_string(lat_long)
      lat_long.map(&:to_s).join(',')
    end
end

CSV($stdout) { |out| out << headers }

distances_from_lat_long(peaks, home).
    # take(1).
    map     { |hash| Hill.new(hash).
                      add_direct_distance.
                      add_road_distances_and_times(sleep_when: ->(hill) {hill.hillnumber.to_i > 0 && hill.hillnumber.to_i % 40 == 0}) }.
    sort_by { |hill| hill.to_hash["direct_distance_in_miles"].to_i }.
    each    { |hill| CSV($stdout) {|out| out << hill.select_columns(headers)} }
