require "../ncurses"

NCurses.start
NCurses.cbreak
NCurses.no_echo
NCurses.mouse_mask NCurses::Mouse::AllEvents

left = NCurses::Window.new(NCurses.height, NCurses.width / 2, 0, 0)
left.keypad true
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
  if ch == NCurses::Key::Mouse
    mse = NCurses.get_mouse
    if mse.enclose? left
      left.print "Mouse interaction inside this window\n"
      left.refresh
    elsif right.enclose? mse
      right.print "Mouse interaction inside this window\n"
      right.print "#{mse}\n"
      right.print "#{mse.relative right}\n"
      right.print "#{right.non_relative(mse.relative(right))}\n"
      right.refresh
    end
  end
end

NCurses.end
