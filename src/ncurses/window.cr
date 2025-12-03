require "../ncurses"

module NCurses
  class Window
    #
    # ## General
    #

    # Create a new window with given size
    #
    # Wrapper for `newwin()`
    def initialize(height = nil, width = nil, y = 0, x = 0)
      max_height, max_width = NCurses.max_x, NCurses.max_y
      initialize(LibNCurses.newwin(height || max_height, width || max_width, y, x))
    end

    # Delete the window
    #
    # Wrapper for `delwin()`
    def delete_window
      LibNCurses.delwin(self)
    end

    # Move window relative to whole screen
    #
    # TODO: Tuple version
    #
    # Wrapper for `mvwin()`
    def move_window(y, x)
      LibNCurses.mvwin(self, y, x)
    end

    # Return height
    #
    # Wrapper for `getmaxy()`
    def max_y
      raise "getmaxy error" if (out = LibNCurses.getmaxy(self)) == ERR
      out
    end

    # Alias for `#max_y`
    def height
      max_y
    end

    # Alias for `#max_y`
    def lines
      max_y
    end

    # Return width
    #
    # Wrapper for `getmaxx()`
    def max_x
      raise "getmaxx error" if (out = LibNCurses.getmaxx(self)) == ERR
      out
    end

    # Alias for `#max_x`
    def width
      max_x
    end

    # Alias for `#max_x`
    def cols
      max_x
    end

    # Max height and width as tuple (y,x)
    def max_dimensions
      {max_y, max_x}
    end

    # Max height and width as named tuple
    def max_dimensions_named
      {y: max_y, x: max_x}
    end

    # Returns cursor current x position
    #
    # Wrapper for `getcurx()`
    def x
      raise "getcurx error" if (out = LibNCurses.getcurx(self)) == ERR
      out
    end

    # Alias for `#x`
    def col
      x
    end

    # Returns cursor current y position
    #
    # Wrapper for `getcury()`
    def y
      raise "getcury error" if (out = LibNCurses.getcury(self)) == ERR
      out
    end

    # Alias for `#y`
    def row
      y
    end

    # Cursor current position as tuple (y,x)
    #
    # Simulates ncurses macro `getyx`
    def pos
      {y, x}
    end

    # Alias for `#pos`
    def position
      pos
    end

    # Cursor current position as named tuple
    def pos_named
      {y: y, x: x}
    end

    # Alias for `#pos_named`
    def position_named
      pos_named
    end

    # Move cursor to new position
    #
    # Wrapper for `wmove()` (`move()`)
    def move(y, x)
      raise "wmove error" if LibNCurses.wmove(self, y, x) == ERR
    end

    # Alias for `#move`
    def set_pos(y, x)
      move y, x
    end

    # Alias for `#move`
    def move(new_pos : Tuple)
      move new_pos[0], new_pos[1]
    end

    # Alias for `#move`
    def set_pos(new_pos : Tuple)
      move new_pos
    end

    # Alias for '#move'
    def move(new_pos : NamedTuple)
      move new_pos[:y], new_pos[:x]
    end

    # Alias for '#move'
    def set_pos(new_pos : NamedTuple)
      move new_pos
    end

    # Refresh window
    #
    # Wrapper for `wrefresh()` (`refresh()`)
    def refresh
      raise "wrefresh error" if LibNCurses.wrefresh(self) == ERR
    end

    # Clear window
    #
    # Wrapper for `werase()` (`erase()`)
    def erase
      raise "werase error" if LibNCurses.werase(self) == ERR
    end

    # Clear window, also causes repaint
    #
    # Wrapper for `wclear()` (`clear()`)
    def clear
      raise "wclear error" if LibNCurses.wclear(self) == ERR
    end

    # Clear window from cursor position to the end of the current line
    #
    # Wrapper for `wclrtoeol()` (`clrtoeol()`)
    def clear_to_eol
      raise "wclrtoeol error" if LibNCurses.wclrtoeol(self) == ERR
    end

    # Clear window from cursor to the rest of the whole window
    #
    # Wrapper for `wclrtobot()` (`clrtoeol()`)
    def clear_to_bot
      raise "wclrtobot error" if LibNCurses.wclrtobot(self) == ERR
    end

    #
    # ## Input options
    #

    # Enable or disable capturing function keys
    def keypad(enable)
      LibNCurses.keypad(self, enable)
    end

    # Wait for input, no errors should be returned
    #
    # Wrapper for `notimeout()`
    def no_timeout
      LibNCurses.nodelay(self, false)
      LibNCurses.notimeout(self, true)
    end

    # Do not wait for input, return ERR
    #
    # Wrapper for `nodelay()`
    def no_delay
      LibNCurses.notimeout(self, false)
      LibNCurses.nodelay(self, true)
    end

    # Set input timeout
    #
    # Wrapper for `wtimeout()` (`timeout()`)
    def timeout=(value)
      LibNCurses.notimeout(self, false)
      LibNCurses.wtimeout(self, value)
    end

    #
    # ## Input
    #

    # Get a character input
    #
    # Returned as `Key` if recognised, `Char` otherwise
    #
    # Wrapper for `wget_wch()` (`get_wch()`)
    def get_char : Key | Char | Nil
      case LibNCurses.wget_wch(self, out key)
      when OK # key is a character
        key.chr
      when KEY_CODE_YES # key is a special key
        Key.from_value?(key)
      else # ERR or something else unexpected
        nil
      end
    end

    # Get a character input for main loop
    def get_char(&block)
      no_timeout
      loop do
        ch = get_char
        yield ch
      end
    end

    #
    # ## Mouse
    #

    # If a mouse position is in this window
    #
    # Wrapper for `wenclose()`
    def enclose?(y, x) : Bool
      LibNCurses.wenclose(self, y, x)
    end

    def enclose?(yx) : Bool
      enclose?(yx[0], yx[1])
    end

    def enclose?(yx : NamedTuple) : Bool
      enclose?(yx[:y], yx[:x])
    end

    # If a mouse event took place within this window
    def enclose?(mouse_event : MouseEvent) : Bool
      enclose?(mouse_event.coordinates)
    end

    # Returns a new `MouseEvent` with coordinates relative to the window
    #
    # To convert back user `#non_relative`
    def relative(event : MouseEvent) : MouseEvent
      event.relative(self)
    end

    def non_relative(event : MouseEvent) : MouseEvent
      event.non_relative(self)
    end

    #
    # ## Output
    #
    # TODO: Add waddstr and waddnstr if needed, could be part of `#print`
    #

    # Draw a character
    #
    # Wrapper for `waddch()` and `mvwaddch()` (`addch()` and `mvaddch()`)
    def add_char(chr, position = nil)
      if position
        return LibNCurses.mvwaddch(self, position[0], position[1], chr) == OK
      else
        return LibNCurses.waddch(self, chr) == OK
      end
    end

    # Alias for `#add_char`
    def add_char(chr, pos_y, pos_x)
      LibNCurses.mvwaddch(self, pos_y, pos_x, chr) == OK
    end

    # Write a string
    #
    # Wrapper for `wprintw()` and `mvwprintw()` (`printw()` and `mvprintw()`)
    def print(message, position = nil)
      if position
        return LibNCurses.mvwprintw(self, position[0], position[1], message) == OK
      else
        return "wprintw error" if LibNCurses.wprintw(self, message) == OK
      end
    end

    # Alias for `#print`
    def print(message, pos_y, pos_x)
      LibNCurses.mvwprintw(self, pos_y, pos_x, message) == OK
    end

    # Draw a box around the edge of a window
    #
    # *ls* - char to be used on left side
    #
    # *rs* - char to be used on right side
    #
    # *ts* - char to be used on top side
    #
    # *bs* - char to be used on bottom side
    #
    # *tl* - char to be used on top left-hand corner
    #
    # *tr* - char to be used on top right-hand corner
    #
    # *bl* - char to be used on bottom left-hand corner
    #
    # *br* - char to be used on bottom right-hand corner
    def border(ls : Char, rs : Char, ts : Char, bs : Char, tl : Char, tr : Char, bl : Char, br : Char)
      LibNCurses.wborder(self, ls.ord, rs.ord, ts.ord, bs.ord, tl.ord, tr.ord, bl.ord, br.ord) == OK
    end

    # Alias for `#border`
    #
    # Uses *hor* for horizontal lines, *ver* for vertical lines, and *cor* for corners
    def border(ver : Char = BORDER_DEFAULT, hor : Char = BORDER_DEFAULT, cor : Char | Nil = nil)
      if cor
        border ver, ver, hor, hor, cor, cor, cor, cor
      else
        box ver, hor
      end
    end

    # Erase around the edge of a window
    def no_border
      border ' ', ' ', ' '
    end

    # Alias for `#border`
    #
    # Same as `#border(ver, hor, BORDER_DEFAULT)`
    def box(ver : Char = BORDER_DEFAULT, hor : Char = BORDER_DEFAULT)
      LibNCurses.box(self, ver.ord, hor.ord) == OK
    end

    def no_box
      no_border
    end

    # Alias for `#print`
    def print(message, row : Int)
      LibNCurses.mvwprintw(self, row, 0, message) == OK
    end

    # Draw a horizontal line
    #
    # Default *char* is `-` and default length is `width`
    def draw_hline(char = nil, length = nil)
      LibNCurses.whline(self, (char || '-').ord, length || max_x)
    end

    # Alias for `#draw_hline`
    def draw_hline(length : Int)
      draw_hline nil, length
    end

    # Draw a vertical line
    def draw_vline(char = nil, height = nil)
      LibNCurses.wvline(self, (char || '|').ord, height || max_y)
    end

    # Alias for `#draw_vline`
    def draw_vline(height : Int)
      draw_vline nil, height
    end

    #
    # ## Background
    #
    # TODO: Check if this works with attributes, provide helper methods?
    #

    # Change the background
    def change_background(char)
      LibNCurses.wbkgdset(self, char.to_u32)
    end

    # Sets a new background and applies it everywhere
    def set_background(char)
      LibNCurses.wbkgd(self, char.to_u32)
    end

    # Get the character and attributes from the current background
    def get_background
      LibNCurses.getbkgd(self)
    end

    #
    # ## Attribute
    #

    # Set this window's default color pair
    #
    # Wrapper for `wcolor_set()` (`color_set()`)
    def set_color(color_pair = 0)
      LibNCurses.wcolor_set(self, color_pair.to_i16, nil)
    end

    # Get the current attributes and color pair
    # as a named tuple with *attr* and *color*
    #
    # Wrapper for `wattr_get()` (`attr_get()`)
    def attr_get
      LibNCurses.wattr_get(self, out attr, out color_pair, nil)
      return {attr: attr, color: color_pair}
    end

    # Alias for `#attr_get`
    def get_attribute
      attr_get
    end

    # Turn off attribute(s)
    #
    # Wrapper for `wattr_off()` (`attr_off()`)
    def attr_off(attr : Attribute)
      LibNCurses.wattr_off(self, attr, nil)
    end

    # Alias for `#attr_off`
    def attribute_off(attr : Attribute)
      attr_off attr
    end

    # Turn on attribute(s)
    #
    # Wrapper for `wattr_on()` (`attr_on()`)
    def attr_on(attr : Attribute)
      LibNCurses.wattr_on(self, attr, nil)
    end

    # Alias for `#attr_on`
    def attribute_on(attr : Attribute)
      attr_on attr
    end

    # Block with attribute(s) turned on
    def with_attr(attrs : Attribute, &block)
      attribute_on(attrs)
      begin
        yield
      ensure
        attribute_off(attrs)
      end
    end

    # Alias for `#with_attr`
    def with_attribute(attrs : Attribute, &block)
      with_attr(attrs) do
        yield
      end
    end

    # Replace attribute(s) and color with these
    #
    # Wrapper for `wattr_set()` (`attr_set()`)
    def set_attr(attr : Attribute = Attribute::Normal, color_pair = 0)
      LibNCurses.wattr_set(self, attr, color_pair.to_i16, nil)
    end

    # Alias for `#set_attr`
    def set_attribute(attr : Attribute = Attribute::Normal, color_pair = 0)
      set_attr attr, color_pair
    end

    # *attr* is the `Attribute` enum.
    # *color_pair* is the color pair number (0 is the default white on black.)
    # *length* defaults to -1, but represents the number of characters to change, up to EOL.
    # If *y* and *x* are set, the cursor location is moved before changing attributes.
    #
    # Wrapper for `wchgat()` and `mvwchgat()` (`chgat()` and `mvchgat()`)
    def change_attribute(attr : Attribute = Attribute::Normal, color_pair = 0, length = -1, y = nil, x = nil)
      if y.nil? || x.nil?
        LibNCurses.wchgat(self, length, attr, color_pair.to_i16, nil)
      else
        LibNCurses.mvwchgat(self, y, x, length, attr, color_pair.to_i16, nil)
      end
    end

    #
    # ## Output options
    #

    # Wrapper for `clearok()`
    def clearok(v : Bool = true)
      LibNCurses.clearok(self, v)
    end

    # Wrapper for `idlok()`
    def idlok(v : Bool = true)
      LibNCurses.idlok(self, v)
    end

    # Wrapper for `idcok()`
    def idcok(v : Bool = true)
      LibNCurses.idcok(self, v)
    end

    # Wrapper for `immedok()`
    def immedok(v : Bool = true)
      LibNCurses.immedok(self, v)
    end

    # Wrapper for `leaveok()`
    def leaveok(v : Bool = true)
      LibNCurses.leaveok(self, v)
    end

    # Wrapper for `wsetscrreg()` & `setscrreg()`
    def setscrreg(top, bot)
      LibNCurses.setscrreg(self, top.to_i32, bot.to_i32)
    end

    # Wrapper for `scrollok()`
    def scrollok(v : Bool = true)
      LibNCurses.scrollok(self, v)
    end
  end
end
