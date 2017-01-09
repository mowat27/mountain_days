#!/usr/bin/env ruby

require 'bundler/setup'

if ARGV.length < 1
  STDERR.puts "Usage #{$0} image [peaks_file]"
  exit 1
end

require_relative '../lib/mountain_days'
include MountainDays

img, peaks_csv = ARGV[0], ARGV[1]

if exif = load_and_validate_image(File.expand_path(img))
  puts "Closest 3 munros"
  peaks = load_peaks(peaks_csv || "./munros.csv")
  distances_from_lat_long(peaks, [exif[:gps_latitude], exif[:gps_longitude] * -1]).
    sort_by {|x| x["distance"] }.take(3).each do |hill|
      puts "  #{hill['hillname']} (#{hill['distance'].to_km} km)"
    end
else
  puts "Sorry, there was no GPS data associated with that picture"
end