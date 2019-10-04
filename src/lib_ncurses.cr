@[Link("ncurses")]

require "./lib_ncurses/*"

lib LibNCurses
  type Window = Void*
  alias FileDescriptor = Int32

  $color_pairs = COLOR_PAIRS : Int32
  $colors = COLORS : Int32

  # Used to color output by creating color pairs
  enum Color : LibC::Short
    Black   = 0
    Red     = 1
    Green   = 2
    Yellow  = 3
    Blue    = 4
    Magenta = 5
    Cyan    = 6
    White   = 7
  end

  # :nodoc:
  struct MEVENT
    id : LibC::Short     # ID for each device
    x, y, z : LibC::Int  # Coordinates
    bstate : LibC::ULong # State bits
  end

  # General functions
  fun initscr : Window
  fun endwin : LibC::Int
  fun curs_set(visibility : LibC::Int) : LibC::Int

  # General window functions
  fun newwin(height : LibC::Int, width : LibC::Int, row : LibC::Int, col : LibC::Int) : Window
  fun delwin(window : Window) : LibC::Int
  fun mvwin(window : Window, y : LibC::Int, x : LibC::Int) : LibC::Int
  fun getcury(window : Window) : LibC::Int
  fun getcurx(window : Window) : LibC::Int
  fun getmaxy(window : Window) : LibC::Int
  fun getmaxx(window : Window) : LibC::Int
  fun wmove(window : Window, row : LibC::Int, col : LibC::Int) : LibC::Int
  fun wrefresh(window : Window) : LibC::Int
  fun wclear(window : Window) : LibC::Int

  # Input option functions
  fun cbreak : LibC::Int
  fun nocbreak : LibC::Int
  fun echo : LibC::Int
  fun noecho : LibC::Int
  fun raw : LibC::Int
  fun noraw : LibC::Int

  # Window input option function
  fun keypad(window : Window, value : Bool)
  fun nodelay(window : Window, value : Bool)
  fun notimeout(window : Window, value : Bool) : LibC::Int
  fun wtimeout(window : Window, timeout : LibC::Int)

  # Input functions
  fun wgetch(window : Window) : LibC::Int
  fun flushinp : LibC::Int

  # Mouse functions
  fun has_mouse : Bool
  fun getmouse(event : MEVENT*) : LibC::Int
  fun mousemask(new_mask : LibC::ULong, old_mask : LibC::ULong*) : LibC::ULong
  fun wenclose(window : Window, y : LibC::Int, x : LibC::Int) : Bool
  fun wmouse_trafo(window : Window, y : LibC::Int*, x : LibC::Int*, to_screen : Bool) : Bool

  # Window output
  fun waddstr(window : Window, str : LibC::Char*) : LibC::Int
  fun waddnstr(window : Window, str : LibC::Char*, n : LibC::Int) : LibC::Int
  fun mvwaddstr(window : Window, y : LibC::Int, x : LibC::Int, str : LibC::Char*) : LibC::Int
  fun mvwaddnstr(window : Window, y : LibC::Int, x : LibC::Int, str : LibC::Char*, n : LibC::Int) : LibC::Int
  fun waddch(window : Window, chr : LibC::Char)
  fun mvwaddch(window : Window, y : LibC::Int, x : LibC::Int, chr : LibC::Char) : LibC::Int
  fun wprintw(window : Window, format : LibC::Char*, ...) : LibC::Int
  fun mvwprintw(window : Window, y : LibC::Int, x : LibC::Int, format : LibC::Char*, ...) : LibC::Int

  # Window background functions
  fun wbkgdset(window : Window, char : LibC::UInt)
  fun wbkgd(window : Window, char : LibC::UInt) : LibC::Int
  fun getbkgd(window : Window) : LibC::UInt

  # Window attribute functions
  fun wcolor_set(window : Window, color_pair : LibC::Short, unused : Void*) : LibC::Int
  fun wattr_get(window : Window, attr : Attribute*, color_pair : LibC::Short*, unused : Void*) : LibC::Int
  fun wattr_off(window : Window, attr : Attribute, unused : Void*) : LibC::Int
  fun wattr_on(window : Window, attr : Attribute, unused : Void*) : LibC::Int
  fun wattr_set(window : Window, attr : Attribute, color_pair : LibC::Short, unused : Void*) : LibC::Int
  fun wchgat(window : Window, n : LibC::Int, attr : Attribute, color_pair : LibC::Short,  unused : Void*) : LibC::Int
  fun mvwchgat(window : Window, y : LibC::Int, x : LibC::Int, n : LibC::Int, attr : Attribute, color_pair : LibC::Short, unused : Void*) : LibC::Int

  # Legacy window attribute functions
  fun wattron(window : Window, attr : Attribute) : LibC::Int
  fun wattroff(window : Window, attr : Attribute) : LibC::Int
  fun wattrset(window : Window, attr : Attribute) : LibC::Int

  # Color functions
  fun start_color : LibC::Int
  fun has_colors : Bool
  fun can_change_color : Bool
  fun init_color(slot : LibC::Short, red : LibC::Short, green : LibC::Short, blue : LibC::Short) : LibC::Int
  fun init_pair(slot : LibC::Short, foreground : LibC::Short, background : LibC::Short) : LibC::Int
end
