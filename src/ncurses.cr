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

  BORDER_DEFAULT = 0.chr

  enum Cursor : LibC::Int
    Invisible      = 0
    Visible        = 1
    HighVisibility = 2
  end

  class Window
    def initialize(@window : LibNCurses::Window)
    end

    def to_unsafe
      @window
    end
  end

  # Start curses mode
  # Wrapper for `initscr()`
  def start
    return if @@initialized
    raise "ncurses init error" unless scr = LibNCurses.initscr
    @@initialized = true
    @@stdscr = Window.new(scr)
  end

  # End curses mode
  # Wrapper for `endwin()`
  def end
    return unless @@initialized
    raise "endwin error" if LibNCurses.endwin == ERR
    @@initialized = false
  end

  # Set the cursor state
  # Use `Cursor` enum
  # Wrapper for `curs_set()`
  def set_cursor(visibility : Cursor)
    LibNCurses.curs_set(visibility) != ERR
  end

  # Get stdscr
  # May remove due to delegateing
  def stdscr
    raise "ncurses not yet initialized" unless scr = @@stdscr
    scr
  end

  #
  # ## Input options
  #

  # Disable buffering, key input is returned with no delay
  # Wrapper for `cbreak()`
  def cbreak
    raise "cbreak error" if LibNCurses.cbreak == ERR
  end

  # Alias for `#cbreak`
  def disable_line_buffer
    cbreak
  end

  # Re-enable buffering until new line
  # Wrapper for `nocbreak()`
  def nocbreak
    raise "nocbreak error" if LibNCurses.nocbreak == ERR
  end

  # Alias for `#nocbreak`
  def enable_line_buffer
    nocbreak
  end

  # If input should be buffered to new lines
  # Enable if true, disable if false
  def line_buffer(option)
    if option
      enable_line_buffer
    else
      disable_line_buffer
    end
  end

  # Re-enable echoing of input back to console
  # Wrapper for `echo()`
  def echo
    LibNCurses.echo
  end

  # Do not echo back to the console
  # Wrapper for `noecho()`
  def no_echo
    LibNCurses.noecho
  end

  # If echoing back to terminal should be enabled
  def echo(option : Bool)
    if option
      echo
    else
      no_echo
    end
  end

  # Disable buffering of input and signals
  # `#cbreak` but also passes signals
  # TODO: Implement signals?
  def raw
    LibNCurses.raw
  end

  # Re-enable buffering of input and signals
  # Wrapper for `noraw()`
  def no_raw
    LibNCurses.noraw
  end

  # If buffering should be disabled for input and signals
  def raw(option)
    if option
      raw
    else
      no_raw
    end
  end

  #
  # ## Input
  #

  # Clear (delete contents of) the input buffer
  # Wrapper for  `flushinp()`
  def flush_input
    raise "flushinp error" if LibNCurses.flushinp == ERR
  end

  #
  # ## Mouse
  #

  # If the terminal has mouse support
  # Wrapper for `has_mouse()`
  def has_mouse
    LibNCurses.has_mouse
  end

  # Should only be called if `#get_char` returned `Key::Mouse`
  # 
  # Returns a `MouseEvent` containing the mouse state and coordinates
  # Wrapper for `getmouse()`
  def get_mouse
    return nil if LibNCurses.getmouse(out event) == ERR
    return MouseEvent.new(event)
  end

  # Default mouse mask
  @@current_mask : LibC::ULong = 0

  # Sets the mouse events that should be returned
  # Should be given a `Mouse` enum
  def mouse_mask(new_mask : Mouse)
    @@current_mask = LibNCurses.mousemask(new_mask, pointerof(@@current_mask))
  end

  #
  # ## Color
  #

  # Start color support
  # Wrapper for `start_color()`
  def start_color
    raise "start_color error" if LibNCurses.start_color == ERR
  end

  # Terminal supports colors
  # Wrapper for `has_colors()`
  def has_colors?
    LibNCurses.has_colors
  end

  # Terminal allows setting custom RGB color values
  # Wrapper for `can_change_color()`
  def can_change_color?
    LibNCurses.can_change_color
  end


  # Change the RGB values of the color
  # Between 0 and 1000
  # ```crystal
  # change_color Color::Red, 0, 0, 1000 # => Color::Red will now appear blue
  # ```
  def init_color(slot, red, green, blue)
    raise "init_color error" if LibNCurses.init_color(slot.to_i16, red.to_i16, green.to_i16, blue.to_i16) == ERR
  end

  # Alias for `#init_color`
  def change_color(slot, red, green, blue)
    init_color slot, red, green, blue
  end

  # Create a color pair to use
  # Pass an integer for id of the pair in the *slot*
  # Pass a `Color` for both the *foreground* and then *background*
  # ```crystal
  # init_color_pair 5, Color::Red, Color::Blue # => Color pair 5 is not red on black
  # ```
  # Wrapper for `init_pair()`
  def init_color_pair(slot, foreground : Color, background : Color)
    raise "init_pair error" if LibNCurses.init_pair(slot.to_i16, foreground.to_i16, background.to_i16) == ERR
  end

  #
  # ## Other
  #

  # Unknown functionality
  # Wrpper for `newterm()`
  def new_term(terminal, out_io, in_io)
    raise "newterm error" unless screen = LibNCurses.newterm(terminal, out_io.fd, in_io.fd)
    puts "foo"
    @@initialized = true
    @@stdscr = Window.new(screen)
  end

  # Unknown functionality
  # Wrapper for `set_term()`
  def term=(screen)
    raise "set_term error" unless LibNCurses.set_term(screen)
    @@stdscr = Window.new(screen)
  end

  #
  # ## Delegation
  #
  # Allows use of namespace to access stdscr
  #

  # General
  delegate max_y, height, lines, max_x, width, cols, to: stdscr
  delegate max_dimensions, max_dimensions_named, to: stdscr
  delegate x, col, y, row, pos, position, pos_named, position_named, to: stdscr
  delegate move, set_pos, refresh, clear, to: stdscr

  # Input
  delegate keypad, no_timeout, no_delay, timeout, to: stdscr
  delegate get_char, to: stdscr

  # Output
  delegate add_char, print, border, box, no_border, no_box, to: stdscr

  # Background
  delegate change_background, set_background, get_background, to: stdscr

  # Attribute
  delegate set_color, attr_get, get_attribute, attr_off, attribute_off, to: stdscr
  delegate attr_on, attribute_on, with_attr, with_attribute, to: stdscr
  delegate set_attr, set_attribute, change_attribute, to: stdscr

  extend self
end
