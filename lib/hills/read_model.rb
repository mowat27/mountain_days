module Hills
  class ReadModel
    def initialize
      @hills = {}
    end

    def hills
      @hills.values
    end

    def[](id)
      @hills[id]
    end

    def load_event(event_name, payload)
      id = payload[:id]

      case(event_name)
      when :new_munro_added
        @hills[id] = Hill.new(payload)
      when :summit_added
        self[id].add_summit(payload[:latitude], payload[:longitude])
      when :starting_point_added
        self[id].add_starting_point(payload[:name], payload[:latitude], payload[:longitude])
      else
        raise EventNotFoundException.new(event_name, payload)
      end
    end
  end

  class Hill
    attr_reader :starting_points, :summit

    def initialize(id:, name:)
      @hill = {id: id, name: name}
      @starting_points = []
    end

    def add_starting_point(name, latitude, longitude)
      @starting_points << Location.new(name, latitude, longitude)
    end

    def add_summit(latitude, longitude)
      @summit = Location.new("summit", latitude, longitude)
    end

    def[](key)
      @hill[key.to_sym]
    end

    def[]=(key, value)
      @hill[key] = value
    end
  end

  class Location < Struct.new(:name, :latitude, :longitude); end

  class EventNotFoundException < Exception
    attr_reader :event_name, :payload

    def initialize(event_name, payload)
      @event_name, @payload = event_name, payload
    end

    def message
      "Unknown event #{event_name}"
    end
  end
end
