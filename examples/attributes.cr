require "../ncurses"

def print_attr(attr : NCurses::Attribute, y_pos = 0, text = "")
  NCurses.with_attribute(attr) do
    NCurses.print("#{text}\n", y_pos, 0)
  end
end

NCurses.start
NCurses.cbreak
NCurses.no_echo

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
print_attr(NCurses::Attribute::Bold, 10, "Bold text...")
print_attr(NCurses::Attribute::Reverse, 11, "Reverse text")
print_attr(NCurses::Attribute::Italic | NCurses::Attribute::Underline, 12, "Underline + Italic")
print_attr(NCurses::Attribute::Standout | NCurses::Attribute::Bold, 13, "Standout + Bold")

NCurses.print "Press q to exit"
NCurses.get_char do |ch|
  break if ch == 113
end

NCurses.end
