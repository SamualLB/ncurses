require "../ncurses"

NCurses.start
NCurses.cbreak
NCurses.no_echo
NCurses.mouse_mask NCurses::Mouse::AllEvents

tl = NCurses::Window.new(NCurses.height / 2, NCurses.width / 2, 0, 0)
tl.keypad true
bl = NCurses::Window.new(NCurses.height / 2, NCurses.width / 2, NCurses.height - (NCurses.height / 2), 0)
tr = NCurses::Window.new(NCurses.height / 2, NCurses.width / 2, 0, NCurses.width - (NCurses.width / 2))
br = NCurses::Window.new(NCurses.height / 2, NCurses.width / 2, NCurses.height - (NCurses.height / 2), NCurses.width - (NCurses.width / 2))

tl.print "Top left!\n"
tl.print "Width: #{tl.width}\n"
tl.print "Height: #{tl.height}\n"

bl.print "Bottom left!\n"
bl.print "Width: #{bl.width}\n"
bl.print "Height: #{bl.height}\n"

br.print "Bottom right!\n"
br.print "Width: #{br.width}\n"
br.print "Height: #{br.height}\n"

tr.print "Top right!\n"
tr.print "Width: #{tr.width}\n"
tr.print "Height: #{tr.height}\n"

tl.print "\nPress q to quit\n"



tl.refresh
bl.refresh
br.refresh
tr.refresh

tl.get_char do |ch|
  break if ch == 113
  if ch == NCurses::Key::Mouse
    mse = NCurses.get_mouse
    if mse.enclose? tl
      tl.print "Mouse interaction inside this window\nNon-relative: #{mse.coordinates}\nRelative: #{mse.relative(tl).coordinates}\n"
      tl.refresh
    elsif mse.enclose? bl
      bl.print "Mouse interaction inside this window\nNon-relative: #{mse.coordinates}\nRelative: #{mse.relative(bl).coordinates}\n"
      bl.refresh
    elsif mse.enclose? br
      br.print "Mouse interaction inside this window\nNon-relative: #{mse.coordinates}\nRelative: #{mse.relative(br).coordinates}\n"
      br.refresh
    elsif tr.enclose? mse
      tr.print "Mouse interaction inside this window\nNon-relative: #{mse.coordinates}\nRelative: #{mse.relative(tr).coordinates}\n"
      tr.refresh
    end
  end
end

NCurses.end
