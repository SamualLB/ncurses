require "./../src/ncurses"

NCurses.start
NCurses.cbreak
NCurses.no_echo

# Exit if terminal does not support colors
unless NCurses.has_colors?
  NCurses.end
  exit(1)
end

NCurses.default_colors
NCurses.start_color

NCurses.init_color_pair(1, NCurses::Color::Red, NCurses::Color::Green)
NCurses.init_color_pair(2, NCurses::Color::Blue, NCurses::Color::Black)
NCurses.init_color_pair(3, NCurses::Color::Black, NCurses::Color::White)
NCurses.init_color_pair(4, NCurses::Color::Cyan, NCurses::Color::Magenta)

# Change color RGB values if terminal supports it
if NCurses.can_change_color?
  NCurses.print "COLOR CHANGE SUPPORTED!\n"
  NCurses.change_color(NCurses::Color::Cyan, 1000, 1000, 1000)
  NCurses.change_color(NCurses::Color::Magenta, 0, 0, 0)
end

NCurses.set_color 1

NCurses.print "Test line!\n"
NCurses.print "  The color has been changed to red on green\n  as that is color pair 1\n"

NCurses.print "\nDump of `#get_attribute` method\n"
NCurses.print "#{NCurses.get_attribute.to_s}\n"
NCurses.print "Shows normal attribute, color is 1, for the color pair\n"

NCurses.set_color 2

NCurses.print "\nNew colors!\nBlue on black!\n"

NCurses.set_color 4

NCurses.print "\nThis should appear to be white on black\n"
NCurses.print "But color pair 4 is cyan on magenta\n"

NCurses.set_color

NCurses.print "\nPress q to exit\n"
NCurses.get_char do |ch|
  break if ch == 'q'
end

NCurses.end
