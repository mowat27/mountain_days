#!/usr/bin/env ruby

require_relative "../lib/mountain_days"

include MountainDays

PROJECT_ROOT = File.expand_path("#{File.dirname($0)}/..")

home = [55.8776447, -4.288019099999929]
peaks = load_peaks(File.expand_path("#{PROJECT_ROOT}/munros.csv"))

distances_from_lat_long(peaks, home).sort_by {|x| x["distance"] }.each do |hill|
  puts "  #{hill['hillname']} (#{hill['distance'].to_km.round} km)"
end
