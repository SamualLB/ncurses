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

  # Special keys recovered when using `NCurses#keypad(true)`
  # 
  # Contains all F keys from 0 to 63
  # 
  # Esc key should not be used
  enum Key : LibC::Int
    Esc           = 27    # Requires 2 inputs?
    UpperA        = 65    # Capital A
    LowerA        = 97    # Lowercase a
    Down          = 0o402 # KEY_DOWN
    Up            = 0o403 # KEY_UP
    Left          = 0o404 # KEY_LEFT
    Right         = 0o405 # KEY_RIGHT
    Home          = 0o406 # KEY_HOME
    Backspace     = 0o407 # KEY_BACKSPACE
    {% for n in (0...64) %}
      F{{n}} = 0o410 + {{n}} # F0 to F63
    {% end %}
    Delete        = 0o512 # KEY_DL
    Insert        = 0o513 # KEY_IC
    ShiftDown     = 0o520 # KEY_SF
    ShiftUp       = 0o521 # KEY_SR
    PageDown      = 0o522 # KEY_NPAGE
    PageUp        = 0o523 # KEY_PPAGE
    Enter         = 0o527 # KEY_ENTER
    ShiftTab      = 0o541 # KEY_BTAB
    End           = 0o550 # KEY_END
    ShiftDelete   = 0o577 # KEY_SDC
    ShiftEnd      = 0o602 # KEY_SEND
    ShiftHome     = 0o607 # KEY_SHOME
    ShiftLeft     = 0o611 # KEY_SLEFT
    ShiftPageDown = 0o614 # KEY_SNEXT
    ShiftPageUp   = 0o616 # KEY_SPREVIOUS
    ShiftRight    = 0o622 # KEY_SRIGHT
    Mouse         = 0o631 # KEY_MOUSE
    Resize        = 0o632 # KEY_RESIZE
  end

  # Used to check for key presses
  # 
  # Uses NCURSES_MOUSE_VERSION 2
  # 
  # If `#get_char` returns `NCurses::Key:Mouse`
  # Check using `NCurses#get_mouse`which returns a `MouseEvent`
  # which contains `#state`
  @[Flags]
  enum Mouse : LibC::ULong
    B1Released      =             0o1 # BUTTON1_RELEASED
    B1Pressed       =             0o2 # BUTTON1_PRESSED
    B1Clicked       =             0o4 # BUTTON1_CLICKED
    B1DoubleClicked =            0o10 # BUTTON1_DOUBLE_CLICKED
    B1TripleClicked =            0o20 # BUTTON1_TRIPLE_CLICKED
    B2Released      =            0o40 # BUTTON2_RELEASED
    B2Pressed       =           0o100 # BUTTON2_PRESSED
    B2Clicked       =           0o200 # BUTTON2_CLICKED
    B2DoubleClicked =           0o400 # BUTTON2_DOUBLE_CLICKED
    B2TripleClicked =         0o1_000 # BUTTON2_TRIPLE_CLICKED
    B3Released      =         0o2_000 # BUTTON3_RELEASED
    B3Pressed       =         0o4_000 # BUTTON3_PRESSED
    B3Clicked       =        0o10_000 # BUTTON3_CLICKED
    B3DoubleClicked =        0o20_000 # BUTTON3_DOUBLE_CLICKED
    B3TripleClicked =        0o40_000 # BUTTON3_TRIPLE_CLICKED
    B4Released      =       0o100_000 # BUTTON4_RELEASED
    B4Pressed       =       0o200_000 # BUTTON4_PRESSED
    B4Clicked       =       0o400_000 # BUTTON4_CLICKED
    B4DoubleClicked =     0o1_000_000 # BUTTON4_DOUBLE_CLICKED
    B4TripleClicked =     0o2_000_000 # BUTTON4_TRIPLE_CLICKED
    B5Released      =     0o4_000_000 # BUTTON5_RELEASED
    B5Pressed       =    0o10_000_000 # BUTTON5_PRESSED
    B5Clicked       =    0o20_000_000 # BUTTON5_CLICKED
    B5DoubleClicked =    0o40_000_000 # BUTTON5_DOUBLE_CLICKED
    B5TripleClicked =   0o100_000_000 # BUTTON5_TRIPLE_CLICKED
    Ctrl            =   0o200_000_000 # BUTTON_CTRL
    Shift           =   0o400_000_000 # BUTTON_SHIFT
    Alt             = 0o1_000_000_000 # BUTTON_ALT
    Position        = 0o2_000_000_000 # REPORT_MOUSE_POSITION
    AllEvents       = 0o1_777_777_777 # ALL_MOUSE_EVENTS
  end

  # :nodoc:
  struct MEVENT
    id : LibC::Short     # ID for each device
    x, y, z : LibC::Int  # Coordinates
    bstate : LibC::ULong # State bits
  end

  fun mousemask(new_mask : LibC::ULong, old_mask : LibC::ULong*) : LibC::ULong
  fun getmouse(event : MEVENT*)
  fun initscr : Window
  fun endwin : LibC::Int
  fun raw : LibC::Int
  fun noraw : LibC::Int
  fun noecho : LibC::Int
  fun wtimeout(window : Window, timeout : LibC::Int)
  fun waddch(window : Window, chr : LibC::Char)
  fun mvwaddch(window : Window, row : LibC::Int, col : LibC::Int, chr : LibC::Char) : LibC::Int
  fun wprintw(window : Window, format : LibC::Char*, ...) : LibC::Int
  fun wgetch(window : Window) : LibC::Int
  fun mvwprintw(window : Window, row : LibC::Int, col : LibC::Int, format : LibC::Char*, ...) : LibC::Int
  fun wrefresh(window : Window) : LibC::Int
  fun keypad(window : Window, value : Bool)
  fun wattron(window : Window, attribute : Attribute) : LibC::Int
  fun wattroff(window : Window, attribute : Attribute) : LibC::Int
  fun wattrset(window : Window, attribute : Attribute) : LibC::Int
  fun getmaxy(window : Window) : LibC::Int
  fun getmaxx(window : Window) : LibC::Int
  fun notimeout(window : Window, value : Bool) : LibC::Int
  fun wmove(window : Window, row : LibC::Int, col : LibC::Int) : LibC::Int
  fun nodelay(window : Window, value : Bool)
  fun wclear(window : Window) : LibC::Int
  fun wbkgd(window : Window, chtype : UInt32)
  fun newwin(height : LibC::Int, width : LibC::Int, row : LibC::Int, col : LibC::Int) : Window
  fun start_color : LibC::Int
  fun has_colors : Bool
  fun can_change_color : Bool
  fun init_color(slot : LibC::Short, red : LibC::Short, green : LibC::Short, blue : LibC::Short) : LibC::Int
  fun init_pair(slot : LibC::Short, foreground : LibC::Short, background : LibC::Short) : LibC::Int
  fun wcolor_set(window : Window, slot : LibC::Short, unused : Void*) : LibC::Int
  fun cbreak : LibC::Int
  fun nocbreak : LibC::Int
  fun flushinp : LibC::Int
  fun curs_set(visibility : LibC::Int) : LibC::Int
  fun move(x : LibC::Int, y : LibC::Int) : LibC::Int
  fun addstr(str : LibC::Char*) : LibC::Int
  fun addch(chr : LibC::Char)
  fun refresh : LibC::Int
  fun clear : LibC::Int
end

