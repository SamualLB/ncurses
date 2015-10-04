require "./lib_ncurses"
require "./ncurses/*"

module NCurses
  alias Key = LibNCurses::Key

  class Window
    def initialize(@window : LibNCurses::Window)
    end

    def to_unsafe
      @window
    end
  end

  def no_echo
    LibNCurses.noecho
  end

  def raw
    LibNCurses.raw
  end

  def init
    return if @@initialized
    scr = LibNCurses.initscr
    raise "couldn't initialize ncurses" unless scr
    @@initialized = true
    @@stdscr = Window.new(scr)
  end

  def stdscr
    scr = @@stdscr
    raise "ncurses not yet initialized" unless scr
    scr
  end

  def new_term(terminal, out_io, in_io)
    screen = LibNCurses.newterm(terminal, out_io.fd, in_io.fd)
    puts "foo"
    @@initialized = true
    @@stdscr = Window.new(screen)
  end

  def term=(screen)
    LibNCurses.set_term(screen)
    @@stdscr = Window.new(screen)
  end

  def end_win
    return unless @@initialized
    LibNCurses.endwin
    @@initialized = false
  end

  extend self
end
