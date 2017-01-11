require 'open-uri'
require 'json'
require_relative '../lib/read_model'

module MountainDays
  class HttpClient
    def initialize(base_url:)
      @base_url = base_url
    end

    def hills
      open_page("read-model.json").map { |hash| HillProxy.new(hash) }
    end

    private
    def open_page(rel_loc)
      JSON.parse open("#{@base_url}/#{rel_loc}").read
    end
  end

  class HillProxy
    attr_reader :hillnumber, :name

    def initialize(hash)
      @hash = hash
      @hillnumber = hash["hillnumber"]
      @name = hash["name"]
    end

    def best_guess_driving_destination
      if !@hash["starting_points"].empty?
        name = @hash["starting_points"].first["name"]
        latitude = @hash["starting_points"].first["latitude"]
        longitude = @hash["starting_points"].first["longitude"]
      else
        name = @hash["summit"]["name"]
        latitude = @hash["summit"]["latitude"]
        longitude = @hash["summit"]["longitude"]
      end
      Location.new(name, latitude, longitude)
    end
  end
end
