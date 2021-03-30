require "./../src/ncurses"

def fill_window(c : String)
  NCurses.height.times do |h|
    NCurses.width.times do |w|
      NCurses.print c, h, w
    end
  end
end

NCurses.start
NCurses.cbreak
NCurses.no_echo
NCurses.no_timeout
NCurses.keypad true

fill_window('#'.to_s)
NCurses.print("Press a key to clear the whole window with `erase`", 0, 0)
NCurses.refresh
NCurses.get_char
NCurses.erase
NCurses.refresh
NCurses.get_char

fill_window('#'.to_s)
NCurses.print("Press a key to clear the whole window with `clear`", 0, 0)
NCurses.refresh
NCurses.get_char
NCurses.clear
NCurses.refresh
NCurses.get_char

fill_window('#'.to_s)
NCurses.print("Press a key to clear to the end of the line with `clear_to_eol`", 0, 0)
NCurses.refresh
NCurses.get_char
NCurses.clear_to_eol
NCurses.refresh
NCurses.get_char

fill_window('#'.to_s)
NCurses.print("Press a key to clear to the end of the window with `clear_to_bot`", 0, 0)
NCurses.refresh
NCurses.get_char
NCurses.clear_to_bot
NCurses.refresh
NCurses.get_char

NCurses.end
