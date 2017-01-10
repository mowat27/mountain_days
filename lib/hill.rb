require_relative 'google_driving_distances'

class Hill
    include MountainDays::RoadDistances

    def initialize(hill)
        @hill = hill.to_hash
        @hill.keys.each do |key|
          define_singleton_method(key) { self[key] }
        end
    end

    def to_hash
        @hill.clone
    end

    def [](key)
      @hill[key]
    end

    def select_columns(headers)
      headers.reduce([]) { |memo, header| memo << self[header] }
    end

    def add_road_distances_and_times(sleep_when: ->(hill) {false}, sleep_for: 1)
        sleep(sleep_for) if sleep_when.call(self)

        journey = journey open(url(from_lat_long, to_lat_long)).read
        STDERR.puts("#{hillnumber},#{hillname},#{journey.status}") if !journey.valid?

        Hill.new(@hill.merge('road_distance_in_miles' => journey.distance_in_metres,
                             'drive_time_in_minutes' => journey.duration_in_seconds))
    end

    def add_direct_distance
      Hill.new(@hill.merge('direct_distance_in_miles' => distance.to_miles.round))
    end

    private
    def as_string(lat_long)
      lat_long.map(&:to_s).join(',')
    end
end
