require "../src/ncurses"

NCurses.start
NCurses.cbreak
NCurses.no_echo

left = NCurses::Window.new(NCurses.height, NCurses.width / 2, 0, 0)
right = NCurses::Window.new(NCurses.height, NCurses.width / 2, 0, NCurses.width - (NCurses.width / 2))

left.print "Given sizes\nHello\n"
left.draw_hline 10 # default char, given width
left.print "World\n", 3
left.draw_hline '?', 10 # given char, given width

left.move 5, 0
left.draw_vline 5 # default char, given height
left.print "Vertical", 5, 1
left.draw_vline '!', 5 # given char, given height

right.print "Default Max Sizes\nHello\n"
right.draw_hline # default char, default max width
right.print "World\n", 3
right.draw_hline '?' # given char, default max width

right.move 5, 0
right.draw_vline # default char, default max height
right.print "Horizontal", 5, 1
right.draw_vline '!' # given char, default max height

NCurses.set_cursor NCurses::Cursor::Invisible
left.print "Press 'q' to quit", NCurses.height - 1
left.refresh
right.refresh

left.get_char do |ch|
  break if ch == 'q'
end

NCurses.end
