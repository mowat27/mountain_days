module MountainDays
  class ReadModel
    def self.hydrate(hills:, starting_points:, locations:)
      read_model = ReadModel.new

      hills.to_a.each do |peak|
        read_model.load_event(:new_munro_added, hillnumber: peak["hillnumber"], name: peak["hillname"])
        read_model.load_event(:summit_added, hillnumber: peak["hillnumber"], latitude: peak["latitude"], longitude: peak["longitude"])
      end

      starting_points.to_a.each do |starting_point|
        read_model.load_event(:starting_point_added, hillnumber: starting_point["hillnumber"], name: "start", latitude: starting_point["latitude"], longitude: starting_point["longitude"])
      end

      read_model
    end

    def to_h
      hills.reduce([]) do |arr, hill|
        arr << hill.to_h
      end
    end

    def initialize
      @hills = {}
    end

    def hills
      @hills.values
    end

    def[](hillnumber)
      @hills[hillnumber]
    end

    def load_event(event_name, payload)
      hillnumber = payload[:hillnumber]

      case(event_name)
      when :new_munro_added
        @hills[hillnumber] = Hill.new(payload)
      when :summit_added
        self[hillnumber].add_summit(payload[:latitude], payload[:longitude])
      when :starting_point_added
        self[hillnumber].add_starting_point(payload[:name], payload[:latitude], payload[:longitude])
      else
        raise EventNotFoundException.new(event_name, payload)
      end
    end
  end

  class Hill
    attr_reader :starting_points, :summit

    def initialize(hillnumber:, name:)
      @hill = {hillnumber: hillnumber, name: name}
      @starting_points = []
    end

    def to_h
      @hill.merge(
        summit: @summit ? @summit.to_h : {},
        starting_points: @starting_points.map(&:to_h)
      )
    end

    def hillnumber
      @hill[:hillnumber]
    end

    def name
      @hill[:name]
    end

    def[](key)
      @hill[key.to_sym]
    end

    def best_guess_driving_destination
      starting_points.first || summit
    end

    def add_summit(latitude, longitude)
      @summit = Location.new("summit", latitude, longitude)
    end

    def add_starting_point(name, latitude, longitude)
      @starting_points << Location.new(name, latitude, longitude)
    end
  end

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
