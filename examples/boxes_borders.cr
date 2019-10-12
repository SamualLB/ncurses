require "../src/ncurses"

NCurses.start
NCurses.cbreak
NCurses.no_echo

width = NCurses.width
height = NCurses.height
win = NCurses::Window.new(height / 2, width / 2, height / 4, width / 4)

msg = "Hello World!"
win.print msg, win.height / 2, (win.width / 2) - (msg.size / 2)

NCurses.set_cursor NCurses::Cursor::Invisible
NCurses.print "Press 't' to toggle border, 'q' to quit", NCurses.height - 1, 0
NCurses.refresh
win.refresh

border = false
NCurses.get_char do |ch|
  if ch == 't'
    if border
      win.no_border
    else
      win.border
    end
    border = !border
    win.refresh
    next
  end
  break if ch == 'q'
end

NCurses.end
