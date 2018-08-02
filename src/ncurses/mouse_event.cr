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

    def initialize(@device_id, @coordinates, @state)
    end

    # If this mouse event took place inside a specific window
    def enclose?(window : Window)
      window.enclose?(self)
    end

    # Returns a new `MouseEvent` with window-relative coordinates
    #
    # Wrapper for `wmouse_trafo()`
    def relative(window : Window) : MouseEvent
      raise "not inside" unless enclose?(window)
      y = @coordinates[:y]
      x = @coordinates[:x]
      unless LibNCurses.wmouse_trafo(window, pointerof(y), pointerof(x), false)
        raise "wmouse_trafo error"
      end
      MouseEvent.new(@device_id, {y: y, x: x, z: @coordinates[:z]}, @state)
    end

    # Returns a new `MouseEvent` with full-screen relative coordinates
    #
    # The opposite of `#relative`
    #
    # Wrapper for `wmouse_trafo()`
    def non_relative(window : Window) : MouseEvent
      y = @coordinates[:y]
      x = @coordinates[:x]
      unless LibNCurses.wmouse_trafo(window, pointerof(y), pointerof(x), true)
        raise "wmouse_trafo error"
      end
      m_e = MouseEvent.new(@device_id, {y: y, x: x, z: @coordinates[:z]}, @state)
      raise "not inside" unless m_e.enclose?(window)
      m_e
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
