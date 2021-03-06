require 'cgi'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'haversine'

module MountainDays
  module RoadDistances
    def base_url
      "https://maps.googleapis.com/maps/api/directions/xml"
    end

    def url(from, to)
      api_key = ENV['GOOGLE_MAPS_API_KEY'] || raise(Error.new("GOOGLE_MAPS_API_KEY not found in environment"))
      "#{base_url}?origin=#{from.join(',')}&destination=#{to.join(',')}&sensor=false&key=#{api_key}"
    end

    class Journey

      def initialize(xml)
        @doc = Nokogiri::XML(xml)
      end

      def status
        @doc.xpath("/DirectionsResponse/status").text
      end

      def valid?
        status == "OK"
      end

      def distance
        node = @doc.xpath("/DirectionsResponse/route/leg/distance/value")
        Distance.new(node.text.to_i)
      end

      def duration_in_seconds
        @doc.xpath("/DirectionsResponse/route/leg/duration").text.to_i
      end
    end

    class NullJourney < Journey
      attr_reader :status

      def initialize(status)
        @status = status
      end

      def distance
        Distance.new(0)
      end
    end

    class Distance
      def initialize(metres)
        @metres = metres
      end

      def to_metres
        @metres
      end

      def to_kilometres
        @metres * 0.0001
      end

      def to_miles
        @metres * 0.000621371
      end
    end

    def journey(xml)
      Journey.new(xml)
    end

    def not_computed
      NullJourney.new("NOT COMPUTED")
    end
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
