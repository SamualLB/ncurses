require "../ncurses"

def print_attr(attr : NCurses::Attribute, y_pos = 0, text = "")
  NCurses.with_attribute(attr) do
    NCurses.print("#{text}\n", y_pos, 0)
  end
end

NCurses.init
NCurses.cbreak
NCurses.no_echo
NCurses.start_color

NCurses.init_color_pair(1, NCurses::Color::Red, NCurses::Color::Green)
NCurses.init_color_pair(2, NCurses::Color::Blue, NCurses::Color::Black)
NCurses.init_color_pair(3, NCurses::Color::Black, NCurses::Color::White)
NCurses.init_color_pair(4, NCurses::Color::Cyan, NCurses::Color::Magenta)

NCurses.init_color(NCurses::Color::Cyan, 1000, 1000, 1000)
NCurses.init_color(NCurses::Color::Magenta, 0, 0, 0)

print_attr(NCurses::Attribute::Standout, 0, "Hello, world! Standout")
print_attr(NCurses::Attribute::Blink, 1, "Blinking!")
print_attr(NCurses::Attribute::Invisible, 2, "This should be invisible")
NCurses.print("    Text above should be invisible", 3, 0)
print_attr(NCurses::Attribute::Dim, 4, "Dim text")
print_attr(NCurses::Attribute::Underline, 5, "Underlined text")
print_attr(NCurses::Attribute::Italic, 6, "Italic text")
print_attr(NCurses::Attribute::AltCharSet, 7, "Alternate character set")
NCurses.print("    I don't know if that works or not", 8, 0)
print_attr(NCurses::Attribute::Top, 9, "Vertical highlight")
print_attr(NCurses::Attribute::ColorPair1, 10, "Red on green!")
print_attr(NCurses::Attribute::ColorPair2, 11, "Blue on black!")
print_attr(NCurses::Attribute::ColorPair3, 12, "Black on white!")
print_attr(NCurses::Attribute::ColorPair4, 13, "Custom colors. Cyan on magenta appears white on black")
print_attr(NCurses::Attribute::Bold, 14, "Bold text...")
print_attr(NCurses::Attribute::Reverse, 15, "Reverse text")


NCurses.get_char do |ch|
  break if ch == 113
end

NCurses.end_win
