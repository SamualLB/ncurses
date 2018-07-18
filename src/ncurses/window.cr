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
    # Wrapper for `wclear()` (`clear()`)
    def clear
      raise "wclear error" if LibNCurses.wclear(self) == ERR
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
    # Returned as `Key` if recognised, int otherwise
    #
    # Wrapper for `wgetch()` (`getch()`)
    def get_char
      raise "wgetch error" if (key = LibNCurses.wgetch(self)) == ERR
      return Key.from_value?(key) || key
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
  end
end
