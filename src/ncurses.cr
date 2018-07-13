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

  # Possible integer result values
  ERR = -1
  OK  =  0

  # Default colors
  BLACK   = 0
  RED     = 1
  GREEN   = 2
  YELLOW  = 3
  BLUE    = 4
  MAGENTA = 5
  CYAN    = 6
  WHITE   = 7

  NCURSES_ATTR_SHIFT = 8

  enum Cursor
    INVISIBLE = 0
    VISIBLE   = 1
    HI_VIZ    = 2
  end

  struct MouseEvent
    @device_id : LibC::Short
    @coordinates : NamedTuple(y: LibC::Int, x: LibC::Int, z: LibC::Int)
    @state = [] of Mouse

    def initialize(event : LibNCurses::MEVENT)
      @device_id = event.id
      @coordinates = {y: event.y, x: event.x, z: event.z}
      parse_state(event.bstate) do |new|
        @state << new
      end
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

  def lines
    max_x
  end

  def cols
    max_y
  end

  @@current_mask : LibC::ULong = 0

  def mouse_mask(new_mask : Mouse)
    @@current_mask = LibNCurses.mousemask(new_mask, pointerof(@@current_mask))
  end

  def get_mouse
    raise "getmouse error" if LibNCurses.getmouse(out event) == ERR
    return MouseEvent.new(event)
  end

  def no_echo
    raise "noecho error" if LibNCurses.noecho == ERR
  end

  def raw
    raise "raw error" if LibNCurses.raw == ERR
  end

  def crmode
    raise "crmode error" if LibNCurses.nocbreak == ERR
  end

  def nocrmode
    raise "nocrmode error" if LibNCurses.cbreak == ERR
  end

  def cbreak
    raise "cbreak error" if LibNCurses.cbreak == ERR
  end

  def nocbreak
    raise "nocbreak error" if LibNCurses.nocbreak == ERR
  end

  def flush_input
    raise "flushinp error" if LibNCurses.flushinp == ERR
  end

  def curs_set(visibility)
    raise "curs_set error" if LibNCurses.curs_set(visibility) == ERR
  end

  def setpos(x, y)
    move(x, y)
  end

  def move(x, y)
    raise "move error" if LibNCurses.move(x, y) == ERR
  end

  def add_string(str)
    raise "addstr error" if LibNCurses.addstr(str) == ERR
  end

  def refresh
    raise "refresh error" if LibNCurses.refresh == ERR
  end

  def clear
    raise "clear error" if LibNCurses.clear == ERR
  end

  def has_colors?
    LibNCurses.has_colors
  end

  def can_change_color?
    LibNCurses.can_change_color
  end

  def color_pairs
    LibNCurses.color_pairs
  end

  def colors
    LibNCurses.colors
  end

  def start_color
    raise "start_color error" if LibNCurses.start_color == ERR
  end

  def init_color(slot, red, green, blue)
    raise "init_color error" if LibNCurses.init_color(slot.to_i16, red.to_i16, green.to_i16, blue.to_i16) == ERR
  end

  def init_color_pair(slot, foreground, background)
    raise "init_pair error" if LibNCurses.init_pair(slot.to_i16, foreground.to_i16, background.to_i16) == ERR
  end

  def init
    return if @@initialized
    raise "ncurses init error" unless scr = LibNCurses.initscr
    @@initialized = true
    @@stdscr = Window.new(scr)
  end

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

  def end_win
    return unless @@initialized
    raise "endwin error" if LibNCurses.endwin == ERR
    @@initialized = false
  end

  def color_pair(n)
    ncurses_bits(n, 0) & a_color
  end

  private def ncurses_bits(mask, shift)
    mask << (shift + NCURSES_ATTR_SHIFT)
  end

  private def a_color
    ncurses_bits((1_u32 << 8) - 1, 0)
  end

  delegate no_timeout, keypad, get_char, print, max_y, max_x, to: stdscr

  extend self
end
