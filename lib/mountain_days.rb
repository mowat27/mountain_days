require 'exif'
require 'csv'
require 'haversine'
require 'ostruct'
require_relative 'google_driving_distances'

module MountainDays
  module App
    class InputFile < Struct.new(:type, :path)
      def to_a
        if type.to_s == "csv"
          load_csv(path)
        else
          raise "Cannot load a file of type '#{type}'"
        end
      end

      def load_csv(ifile)
        csv = CSV.read(ifile, encoding: "ISO8859-1")
        headers, rows = csv.shift.map {|hdr| hdr.strip}, csv

        peaks = rows.reduce([]) do |res, row|
          res << Hash[headers.zip(row)]
        end
      end
    end

    ROOT = File.expand_path("#{File.dirname($PROGRAM_NAME)}/..")
    DATA = File.join(ROOT, "data")
    FILES = OpenStruct.new(
      munros: InputFile.new(:csv, "#{DATA}/munros.csv"),
      starting_points: InputFile.new(:csv, "#{DATA}/starting_points.csv"),
      locations: InputFile.new(:csv, "#{DATA}/locations.csv"),
    )
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

  module Journeys
    extend MountainDays::RoadDistances

    def self.direct_distance(from, to)
      Haversine.distance(from.lat_long, to.lat_long)
    end

    def self.road_journey(from, to)
      journey open(url(from.lat_long, to.lat_long)).read
    end
  end
end
