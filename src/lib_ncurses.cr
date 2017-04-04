@[Link("ncurses")]

lib LibNCurses
  type Window = Void*
  alias FileDescriptor = Int32

  ATTR_SHIFT = 8_u32

  enum Attribute
    NORMAL     = 1_u32 - 1_u32
    ATTRIBUTES = 1_u32                      << ( 0_u32 + ATTR_SHIFT)
    CHARTEXT   = (1_u32                     << ( 0_u32 + ATTR_SHIFT)) - 1_u32
    COLOR      = ((1_u32 << 8_u32) - 1_u32) << ( 0_u32 + ATTR_SHIFT)
    STANDOUT   = 1_u32                      << ( 8_u32 + ATTR_SHIFT)
    UNDERLINE  = 1_u32                      << ( 9_u32 + ATTR_SHIFT)
    REVERSE    = 1_u32                      << (10_u32 + ATTR_SHIFT)
    BLINK      = 1_u32                      << (11_u32 + ATTR_SHIFT)
    DIM        = 1_u32                      << (12_u32 + ATTR_SHIFT)
    BOLD       = 1_u32                      << (13_u32 + ATTR_SHIFT)
    ALTCHARSET = 1_u32                      << (14_u32 + ATTR_SHIFT)
    INVIS      = 1_u32                      << (15_u32 + ATTR_SHIFT)
    PROTECT    = 1_u32                      << (16_u32 + ATTR_SHIFT)
    HORIZONTAL = 1_u32                      << (17_u32 + ATTR_SHIFT)
    LEFT       = 1_u32                      << (18_u32 + ATTR_SHIFT)
    LOW        = 1_u32                      << (19_u32 + ATTR_SHIFT)
    RIGHT      = 1_u32                      << (20_u32 + ATTR_SHIFT)
    TOP        = 1_u32                      << (21_u32 + ATTR_SHIFT)
    VERTICAL   = 1_u32                      << (22_u32 + ATTR_SHIFT)
    ITALIC     = 1_u32                      << (23_u32 + ATTR_SHIFT)
  end

  enum Key
    DOWN      = 0o402
    UP        = 0o403
    LEFT      = 0o404
    RIGHT     = 0o405
    HOME      = 0o406
    BACKSPACE = 0o407
    F1        = 0o410 + 1
    F2        = 0o410 + 2
    F3        = 0o410 + 3
    F4        = 0o410 + 4
    F5        = 0o410 + 5
    F6        = 0o410 + 6
    F7        = 0o410 + 7
    F8        = 0o410 + 8
    F9        = 0o410 + 9
    F10       = 0o410 + 10
    F11       = 0o410 + 11
    F12       = 0o410 + 12
    ENTER     = 0o527
  end

  fun initscr : Window
  fun endwin
  fun raw
  fun cbreak
  fun noecho
  fun wtimeout(window : Window, timeout : Int32)
  fun wprintw(window : Window, format : UInt8*, ...)
  fun wgetch(window : Window) : Int32
  fun mvwprintw(window : Window, row : Int32, col : Int32, format : UInt8*, ...)
  fun wrefresh(window : Window)
  fun keypad(window : Window, value : Bool)
  fun wattr_on(window : Window, attribute : Attribute, unused : Void*)
  fun wattr_off(window : Window, attribute : Attribute, unused : Void*)
  fun getmaxy(window : Window) : Int32
  fun getmaxx(window : Window) : Int32
  fun notimeout(window : Window, value : Bool)
  fun nodelay(window : Window, value : Bool)
  fun wclear(window : Window)
  fun newwin(height : Int32, width : Int32, row : Int32, col : Int32) : Window
  fun start_color : Int32
  fun has_colors : Bool
  fun can_change_color : Bool
  fun init_color(slot : Int16, red : Int16, green : Int16, blue : Int16) : Int32
  fun init_pair(slot : Int16, foreground : Int16, background : Int16) : Int32
  fun wcolor_set(window : Window, slot : Int16, unused : Void*) : Int32
end
