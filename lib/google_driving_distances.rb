require 'cgi'
require 'net/http'
require 'open-uri'
require 'nokogiri'

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

      def distance_in_metres
        @doc.xpath("/DirectionsResponse/route/leg/distance/value").text.to_i
      end

      def duration_in_seconds
        @doc.xpath("/DirectionsResponse/route/leg/duration").text.to_i
      end
    end

    def journey(xml)
      Journey.new(xml)
    end
  end
end
