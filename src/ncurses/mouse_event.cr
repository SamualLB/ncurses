module NCurses
  # Returned by `#get_mouse` after `Key::Mouse` has been returned
  struct MouseEvent
    getter device_id : Int16
    getter coordinates : NamedTuple(y: Int32, x: Int32, z: Int32)
    getter state : Mouse

    # Converts fields from LibC ints to specific types
    def initialize(event : LibNCurses::MEVENT)
      @device_id = event.id.to_i16
      @coordinates = {y: event.y.to_i32, x: event.x.to_i32, z: event.z.to_i32}
      @state = Mouse.new(event.bstate)
    end

    # Because of Mouse::AllEvents, instances must be checked for actual contents
    private def parse_state(state : LibC::ULong, &block)
      state = Mouse.new(state)
      Mouse.each do |member, value|
        yield member if state.includes?(member) unless member == Mouse::AllEvents
      end
    end
  end
end
