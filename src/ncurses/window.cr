require "../ncurses"

module NCurses
  class Window
    # Create a new window with given size
    def initialize(height = nil, width = nil, y = 0, x = 0)
      max_height, max_width = NCurses.max_x, NCurses.max_y
      initialize(LibNCurses.newwin(height || max_height, width || max_width, y, x))
    end

    # Return width
    def max_x
      raise "getmaxx error" if (out = LibNCurses.getmaxx(self)) == ERR
      out
    end

    # Return height
    def max_y
      raise "getmaxy error" if (out = LibNCurses.getmaxy(self)) == ERR
      out
    end

    # Alias for `#max_x`
    def cols
      max_x
    end

    # Alias for `#max_y`
    def lines
      max_y
    end

    # Max height and width
    def max_dimensions
      {y: max_y, x: max_x}
    end

    # Set this window's default color pair
    def set_color(color_pair)
      LibNCurses.wcolor_set(self, color_pair.to_i16, nil)
    end

    # Get the current attributes and color pair
    # As a named tuple with *attr* and *color*
    def get_attribute
      LibNCurses.wattr_get(self, out attr, out color_pair, nil)
      return {attr: attr, color: color_pair}
    end

    # Turn off attribute(s)
    def attribute_off(attr : Attribute)
      LibNCurses.wattr_off(self, attr, nil)
    end

    # Turn on attribute(s)
    def attribute_on(attr : Attribute)
      LibNCurses.wattr_on(self, attr, nil)
    end

    # Block with attribute(s) turned on
    def with_attribute(attrs : Attribute, &block)
      attribute_on(attrs)
      begin
        yield
      ensure
        attribute_off(attrs)
      end
    end

    # Replace attribute(s) and color with these
    def set_attribute(attr : Attribute = Attribute::Normal, color_pair = 0)
      LibNCurses.wattrset(self, attr, color_pair.to_i16, nil)
    end

    # chgat wrapper
    # *attr* is the `Attribute` enum
    # *color_pair* is the color pair number (0 is the default white on black)
    # *length* defaults to -1, but represents the number of characters to change, up to EOL
    # If *y* and *x* are set, the cursor location is moved before changing attributes
    def change_attribute(attr : Attribute = Attribute::Normal, color_pair = 0, length = -1, y = nil, x = nil)
      if y.nil? || x.nil?
        LibNCurses.wchgat(self, length, attr, color_pair.to_i16, nil)
      else
        LibNCurses.mvwchgat(self, y, x, length, attr, color_pair.to_i16, nil)
      end
    end

    # Get a character input
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

    # Enable or disable capturing function keys
    def keypad(enable)
      LibNCurses.keypad(self, enable)
    end

    # Wait for input
    def no_timeout
      LibNCurses.nodelay(self, false)
      LibNCurses.notimeout(self, true)
    end

    # Do not wait for input, return ERR
    def no_delay
      LibNCurses.notimeout(self, false)
      LibNCurses.nodelay(self, true)
    end

    # Set input timeout
    def timeout=(value)
      LibNCurses.notimeout(self, false)
      LibNCurses.wtimeout(self, value)
    end

    # Draw a character
    def add_char(chr, position = nil)
      if position
        return LibNCurses.mvwaddch(self, position[0], position[1], chr) == OK
      else
        return LibNCurses.waddch(self, chr) == OK
      end
    end

    # ditto
    def add_char(chr, pos_y, pos_x)
      LibNCurses.mvwaddch(self, pos_y, pos_x, chr) == OK
    end

    # Write a string
    def print(message, position = nil)
      if position
        return LibNCurses.mvwprintw(self, position[0], position[1], message) == OK
      else
        return "wprintw error" if LibNCurses.wprintw(self, message) == OK
      end
    end

    # ditto
    def print(message, pos_y, pos_x)
      LibNCurses.mvwprintw(self, pos_y, pos_x, message) == OK
    end

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

    # Move cursor to new position
    def move(y, x)
      raise "wmove error" if LibNCurses.wmove(self, y, x) == ERR
    end

    # Alias for `#move`
    def set_pos(y, x)
      move y, x
    end

    # Clear window
    def clear
      raise "wclear error" if LibNCurses.wclear(self) == ERR
    end

    # Refresh window
    def refresh
      raise "wrefresh error" if LibNCurses.wrefresh(self) == ERR
    end
  end
end
