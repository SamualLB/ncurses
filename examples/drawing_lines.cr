require "../src/ncurses"

NCurses.start
NCurses.cbreak
NCurses.no_echo

left = NCurses::Window.new(NCurses.height, NCurses.width / 2, 0, 0)
right = NCurses::Window.new(NCurses.height, NCurses.width / 2, 0, NCurses.width - (NCurses.width / 2))

left.print "Left Side!\nHello\n"
left.draw_hline 20 # default char, given width
left.print "World\n", 3
left.draw_hline '?', 20 # given char, given width

right.print "Right Side!\nHello\n"
right.draw_hline # default char, default max width
right.print "World\n", 3
right.draw_hline '?' # given char, default max width

NCurses.set_cursor NCurses::Cursor::Invisible
left.print "Press 'q' to quit", NCurses.height - 1
left.refresh
right.refresh

left.get_char do |ch|
  break if ch == 'q'
end

NCurses.end
