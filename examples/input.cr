require "./../src/ncurses"

NCurses.start
NCurses.cbreak
NCurses.no_echo
NCurses.no_timeout
NCurses.keypad true
NCurses.mouse_mask(NCurses::Mouse::AllEvents | NCurses::Mouse::Position)

NCurses::Key.each do |key|
  NCurses.print(key.to_s)
end
NCurses.print "\n\nPress something!"

NCurses.refresh

NCurses.get_char do |ch|
  NCurses.clear
  NCurses.print(ch.to_s, 0, 0)
  NCurses.refresh
  break if ch == 'q'
  if ch == NCurses::Key::Mouse
    mouse = NCurses.get_mouse
    NCurses.print(mouse.to_s, 1, 0)
  end
  NCurses.print "\n\nPress q to quit"
end

NCurses.end
