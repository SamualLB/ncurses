require "./lib_ncurses"
require "./ncurses/*"

lib Locale
  # LC_CTYPE is probably 0 (at least in glibc)
  LC_CTYPE = 0
  fun setlocale(category : Int32, locale : LibC::Char*) : LibC::Char*
end

Locale.setlocale(Locale::LC_CTYPE, "")

module NCurses
  alias Key = LibNCurses::Key
  alias Mouse = LibNCurses::Mouse
  alias Attribute = LibNCurses::Attribute
  alias Color = LibNCurses::Color

  # Possible integer result values
  ERR = -1
  OK  =  0

  NCURSES_ATTR_SHIFT = 8

  enum Cursor : LibC::Int
    Invisible      = 0
    Visible        = 1
    HighVisibility = 2
  end

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

    private def parse_state(state : LibC::ULong, &block)
      state = Mouse.new(state)
      Mouse.each do |member, value|
        yield member if state.includes?(member) unless member == Mouse::AllEvents
      end
    end
  end

  class Window
    def initialize(@window : LibNCurses::Window)
    end

    def to_unsafe
      @window
    end
  end

  # Default mouse mask
  @@current_mask : LibC::ULong = 0

  # Sets the mouse events that should be returned
  # Should be given a `Mouse` enum
  def mouse_mask(new_mask : Mouse)
    @@current_mask = LibNCurses.mousemask(new_mask, pointerof(@@current_mask))
  end

  # Should only be called if `#get_char` returned `Key::Mouse`
  # 
  # Returns a `MouseEvent` containing the mouse state and coordinates
  def get_mouse
    raise "getmouse error" if LibNCurses.getmouse(out event) == ERR
    return MouseEvent.new(event)
  end

  # Do not echo back to the console
  def no_echo
    raise "noecho error" if LibNCurses.noecho == ERR
  end

  # `#cbreak` but also passes signals
  # TODO: Implement signals?
  def raw
    raise "raw error" if LibNCurses.raw == ERR
  end

  # Alias for `#nocbreak`
  def enable_line_buffer
    raise "crmode error" if LibNCurses.nocbreak == ERR
  end

  # Alias for `#cbreak`
  def disable_line_buffer
    raise "nocrmode error" if LibNCurses.cbreak == ERR
  end

  # Disable buffering until new line
  def cbreak
    raise "cbreak error" if LibNCurses.cbreak == ERR
  end

  # Re-enable buffering until new line
  def nocbreak
    raise "nocbreak error" if LibNCurses.nocbreak == ERR
  end

  # Wraps flushinp() to clear the input buffer
  def flush_input
    raise "flushinp error" if LibNCurses.flushinp == ERR
  end

  # Set the cursor state
  # Use `Cursor` enum
  def curs_set(visibility)
    LibNCurses.curs_set(visibility) == OK
  end

  # Alias for `#move`
  def set_pos(y, x)
    move(y, x)
  end

  # Move the cursor to the coordinates
  def move(y, x)
    raise "move error" if LibNCurses.move(y, x) == ERR
  end

  # Wrapper for addstr
  # Writes each character until end of the terminal line or string
  def add_string(str)
    raise "addstr error" if LibNCurses.addstr(str) == ERR
  end

  # Refresh the window
  def refresh
    raise "refresh error" if LibNCurses.refresh == ERR
  end

  # Clear the window
  def clear
    raise "clear error" if LibNCurses.clear == ERR
  end

  # Terminal supports colors
  def has_colors?
    LibNCurses.has_colors
  end

  # Terminal allows setting RGB color values
  def can_change_color?
    LibNCurses.can_change_color
  end
 
  #def color_pairs
  #  LibNCurses.color_pairs
  #end


  #def colors
  #  LibNCurses.colors
  #end

  # Start color support
  def start_color
    raise "start_color error" if LibNCurses.start_color == ERR
  end

  # Change the RGB values of the color
  def init_color(slot, red, green, blue)
    raise "init_color error" if LibNCurses.init_color(slot.to_i16, red.to_i16, green.to_i16, blue.to_i16) == ERR
  end

  # ditto
  def change_color(slot, red, green, blue)
    init_color slot, red, green, blue
  end

  # Create a color pair to use
  def init_color_pair(slot, foreground : Color, background : Color)
    raise "init_pair error" if LibNCurses.init_pair(slot.to_i16, foreground.to_i16, background.to_i16) == ERR
  end

  # Start curses mode
  def init
    return if @@initialized
    raise "ncurses init error" unless scr = LibNCurses.initscr
    @@initialized = true
    @@stdscr = Window.new(scr)
  end

  # Get stdscr
  def stdscr
    raise "ncurses not yet initialized" unless scr = @@stdscr
    scr
  end

  def new_term(terminal, out_io, in_io)
    raise "newterm error" unless screen = LibNCurses.newterm(terminal, out_io.fd, in_io.fd)
    puts "foo"
    @@initialized = true
    @@stdscr = Window.new(screen)
  end

  def term=(screen)
    raise "set_term error" unless LibNCurses.set_term(screen)
    @@stdscr = Window.new(screen)
  end

  # End curses mode
  def end_win
    return unless @@initialized
    raise "endwin error" if LibNCurses.endwin == ERR
    @@initialized = false
  end

  # Get a color pair
  def color_pair(n)
    ncurses_bits(n, 0) & a_color
  end

  private def ncurses_bits(mask, shift)
    mask << (shift + NCURSES_ATTR_SHIFT)
  end

  private def a_color
    ncurses_bits((1_u32 << 8) - 1, 0)
  end

  # Send `Window` methods to stdscr
  delegate no_timeout, keypad, get_char, print, max_y, max_x, attr_on, attr_off, with_attr, to: stdscr

  extend self
end
