module Hills
  class ReadModel
    attr_reader :hills

    def initialize
      @hills = []
    end

    def[](id)
      @hills.find { |hill| hill[:id] == id }
    end

    def load_event(event_name, payload)
      id = payload[:id]

      case(event_name)
      when :new_munro_added
        @hills << Hill.new(payload)
      when :summit_latitude_added
        self[id][:summit_latitude] = payload[:value]
      when :summit_longitude_added
        self[id][:summit_longitude] = payload[:value]
      when :starting_point_added
        self[id].add_starting_point(payload[:name], payload[:latitude], payload[:longitude])
      end
    end
  end

  class Hill
    attr_reader :starting_points

    def initialize(id:, name:)
      @hill = {id: id, name: name}
      @starting_points = []
    end

    def add_starting_point(name, latitude, longitude)
      @starting_points << Location.new(name, latitude, longitude)
    end

    def[](key)
      @hill[key.to_sym]
    end

    def[]=(key, value)
      @hill[key] = value
    end
  end

  class Location
    def initialize(name, latitude, longitude)
      @name, @latitude, @longitude = name, latitude, longitude
    end

    def[](key)
      case key
      when "name"
        @name
      when "latitude"
        @latitude
      when "longitude"
        @longitude
      end
    end
  end
end
