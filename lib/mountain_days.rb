require 'csv'
require 'ostruct'
require 'haversine'

require_relative 'travel'
require_relative 'read_model'

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

    ROOT = File.expand_path("#{File.dirname(__FILE__)}/..")
    DATA = File.join(ROOT, "data")
    FILES = OpenStruct.new(
      munros: InputFile.new(:csv, "#{DATA}/munros.csv"),
      starting_points: InputFile.new(:csv, "#{DATA}/starting_points.csv"),
      locations: InputFile.new(:csv, "#{DATA}/locations.csv"),
    )
  end
end
