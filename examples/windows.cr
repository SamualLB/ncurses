require "../ncurses"

NCurses.start
NCurses.cbreak
NCurses.no_echo

left = NCurses::Window.new(NCurses.height, NCurses.width / 2, 0, 0)
right = NCurses::Window.new(NCurses.height, NCurses.width / 2, 0, NCurses.width - (NCurses.width / 2))

left.print "Left side!\n"
left.print "Width: #{left.width}\n"
left.print "Height: #{left.height}\n"

right.print "Right side!\n"
right.print "Width: #{right.width}\n"
right.print "Height: #{right.height}\n"

left.print "\nPress q to quit\n"

left.refresh
right.refresh

left.get_char do |ch|
  break if ch == 113
end

NCurses.end
