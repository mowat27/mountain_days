require 'open-uri'
require 'json'
require 'ostruct'

module MountainDays
  class HttpClient
    class Location < Struct.new(:name, :latitude, :longitude)
      def lat_long
        [latitude.to_f, longitude.to_f]
      end

      def to_h
        {
          name: name,
          latitude: latitude,
          longitude: longitude
        }
      end
    end

    def initialize(base_url:)
      @base_url = base_url
    end

    def hills
      open_page("read-model.json").map { |hash| HillProxy.new(hash) }
    end

    private
    def open_page(rel_loc)
      JSON.parse(open("#{@base_url}/#{rel_loc}").read, object_class: OpenStruct)
    end
  end

  class HillProxy
    def initialize(hill)
      @hill = hill
    end

    def respond_to?(mth)
      return true if super(mth.to_sym)
      @hill.respond_to?(mth.to_sym)
    end

    def method_missing(mth, *args)
      @hill.respond_to?(mth) ? @hill.send(mth, *args) : super(mth, *args)
    end

    def best_guess_driving_destination
      dest = @hill.starting_points.empty? ? @hill.summit : @hill.starting_points.first
      HttpClient::Location.new(dest.name, dest.latitude, dest.longitude)
    end
  end
end
