#!/usr/bin/env ruby

require 'bundler/setup'
require 'exif'
require 'csv'
require 'haversine'
require 'bigdecimal'

if ARGV.length < 1
  STDERR.puts "Usage #{$0} image [peaks_file]"
  exit 1
end

img, peaks_csv = ARGV[0], ARGV[1]

def load_peaks(ifile)
  csv = CSV.read(ifile, encoding: "ISO8859-1")
  headers, rows = csv.shift.map {|hdr| hdr.strip}, csv

  peaks = rows.reduce([]) do |res, row|
    res << Hash[headers.zip(row)]
  end
end

def distances(peaks, exif)
  img_loc = [exif[:gps_latitude], exif[:gps_longitude] * -1]

  peaks.reduce([]) do |arr, peak|
    peak_loc = [peak["latitude"], peak["longitude"]].map(&:to_f)
    arr << {
      "hillname" => peak["hillname"],
      "hill_lat_long" => peak_loc,
      "image_lat_long" => img_loc,
      "distance" => Haversine.distance(img_loc, peak_loc),
      "hill" => peak,
      "exif" => exif
    }
  end
end

puts "Closest 3 munros"
distances(load_peaks(peaks_csv || "./munros.csv"), Exif::Data.new(img)).sort_by {|x| x["distance"] }.take(3).each do |hill|
  puts "  #{hill['hillname']} (#{hill['distance'].to_km} km)"
end
