# Test scrollok

require "../src/ncurses"

NCurses.start

(NCurses.height + 5).times do |i|
  NCurses.print("Line #{i+1}: fdsfsdhgsh\n")
end

NCurses.refresh
NCurses.get_char

NCurses.clear
NCurses.scrollok

(NCurses.height + 10).times do |i|
  NCurses.print("Line #{i+1}: fdsfsdhgsh\n")
end

NCurses.refresh
NCurses.get_char

NCurses.end
