require 'csv'
require 'ostruct'
require 'haversine'

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
