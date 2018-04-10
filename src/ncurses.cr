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

  class Window
    def initialize(@window : LibNCurses::Window)
    end

    def to_unsafe
      @window
    end
  end

  def lines
    if stdscr = @@stdscr
      LibNCurses.getmaxy(stdscr.to_unsafe)
    end
  end

  def cols
    if stdscr = @@stdscr
      LibNCurses.getmaxx(stdscr.to_unsafe)
    end
  end

  def no_echo
    LibNCurses.noecho
  end

  def raw
    LibNCurses.raw
  end

  def crmode
    if ERR == LibNCurses.nocbreak
      raise "Unable to switch to crmode"
    end
  end

  def nocrmode
    if ERR == LibNCurses.cbreak
      raise "Unable to switch out of crmode"
    end
  end

  def cbreak
    if ERR == LibNCurses.cbreak
      raise "Unable to switch to cbreak"
    end
  end

  def nocbreak
    if ERR == LibNCurses.nocbreak
      raise "Unable to switch out of cbreak"
    end
  end

  def flush_input
    LibNCurses.flushinp
  end

  def curs_set(visibility)
    if ERR == LibNCurses.curs_set(visibility)
      raise "Unable to set cursor visibility"
    end
  end

  def setpos(x, y)
    move(x, y)
  end

  def move(x, y)
    if ERR == LibNCurses.move(x, y)
      raise "Unable to set cursor position"
    end
  end

  def addstr(str)
    if ERR == LibNCurses.addstr(str)
      raise "Unable to add string"
    end
  end

  def refresh
    LibNCurses.refresh
  end

  def clear
    LibNCurses.clear
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
    if ERR == LibNCurses.start_color
      raise "Unable to start color mode"
    end
  end

  def init_color(slot, red, green, blue)
    if ERR == LibNCurses.init_color(slot.to_i16, red.to_i16, green.to_i16, blue.to_i16)
      raise "Unable to init color"
    end
  end

  def init_color_pair(slot, foreground, background)
    if ERR == LibNCurses.init_pair(slot.to_i16, foreground.to_i16, background.to_i16)
      raise "Unable to init color pair"
    end
  end

  def init
    return if @@initialized
    scr = LibNCurses.initscr
    raise "couldn't initialize ncurses" unless scr
    @@initialized = true
    @@stdscr = Window.new(scr)
  end

  def stdscr
    scr = @@stdscr
    raise "ncurses not yet initialized" unless scr
    scr
  end

  def new_term(terminal, out_io, in_io)
    screen = LibNCurses.newterm(terminal, out_io.fd, in_io.fd)
    puts "foo"
    @@initialized = true
    @@stdscr = Window.new(screen)
  end

  def term=(screen)
    LibNCurses.set_term(screen)
    @@stdscr = Window.new(screen)
  end

  def end_win
    return unless @@initialized
    LibNCurses.endwin
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

  extend self
end
