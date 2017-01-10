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
      case(event_name)
      when :new_munro_added
        @hills << payload
      when :summit_latitude_added
        self[payload[:id]]["summit_latitude"] = payload[:value]
      when :summit_longitude_added
        self[payload[:id]]["summit_longitude"] = payload[:value]
      end
    end
  end
end
