#!/usr/bin/env ruby

require 'bundler/setup'
require 'exif'
require 'haversine'
require 'csv'

if ARGV.length < 1
  STDERR.puts "Usage #{$0} image [peaks_file]"
  exit 1
end

def distances_from_lat_long(peaks, lat_long)
  peaks.reduce([]) do |arr, peak|
    peak_loc = [peak["latitude"], peak["longitude"]].map(&:to_f)
    arr << peak.merge(
      "from_lat_long" => lat_long,
      "to_lat_long" => peak_loc,
      "distance" => Haversine.distance(lat_long, peak_loc)
    )
  end
end

def load_and_validate_image(img)
  exif = Exif::Data.new(img)
  return nil if !exif[:gps_latitude] || !exif[:gps_longitude]
  exif
end

def load_peaks(ifile)
  csv = CSV.read(ifile, encoding: "ISO8859-1")
  headers, rows = csv.shift.map {|hdr| hdr.strip}, csv

  peaks = rows.reduce([]) do |res, row|
    res << Hash[headers.zip(row)]
  end
end

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
