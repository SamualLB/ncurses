require "../ncurses"

NCurses.init
NCurses.cbreak
NCurses.no_echo
NCurses.no_timeout
NCurses.keypad true
NCurses.mouse_mask(NCurses::Mouse::AllEvents)

NCurses.get_char do |ch|
  NCurses.clear
  NCurses.print(ch.to_s, 0, 0)
  NCurses.refresh
  break if ch == 113
  if ch == NCurses::Key::Mouse
    mouse = NCurses.get_mouse
    NCurses.print(mouse.to_s, 1, 0)
  end
end

NCurses.end_win
