lib LibNCurses
  # Used to check for key presses
  # 
  # Uses NCURSES_MOUSE_VERSION 2
  # 
  # If `#get_char` returns `NCurses::Key:Mouse`
  # Check using `NCurses#get_mouse`which returns a `MouseEvent`
  # which contains `#state`
  @[Flags]
  enum Mouse : LibC::ULong
    # B1: Left Button
    # BUTTON1_RELEASED
    B1Released = 0o1

    # BUTTON1_PRESSED
    B1Pressed = 0o2

    # BUTTON1_CLICKED
    B1Clicked = 0o4

    #BUTTON1_DOUBLE_CLICKED
    B1DoubleClicked = 0o10

    #BUTTON1_TRIPLE_CLICKED
    B1TripleClicked = 0o20

    # B2: Middle Button (scroll wheel)
    # BUTTON2_RELEASED
    B2Released = 0o40

    # BUTTON2_PRESSED
    B2Pressed = 0o100

    # BUTTON2_CLICKED
    B2Clicked = 0o200

    # BUTTON2_DOUBLE_CLICKED
    B2DoubleClicked = 0o400

    # BUTTON2_TRIPLE_CLICKED
    B2TripleClicked = 0o1_000

    # B3: Right button
    # BUTTON3_RELEASED
    B3Released = 0o2_000

    # BUTTON3_PRESSED
    B3Pressed = 0o4_000

    # BUTTON3_CLICKED
    B3Clicked = 0o10_000

    # BUTTON3_DOUBLE_CLICKED
    B3DoubleClicked = 0o20_000

    # BUTTON3_TRIPLE_CLICKED
    B3TripleClicked = 0o40_000

    # B4: ???
    # TODO: Description for Button 4 on mouse
    # BUTTON4_RELEASED
    B4Released = 0o100_000

    # BUTTON4_PRESSED
    B4Pressed = 0o200_000

    # BUTTON4_CLICKED
    B4Clicked = 0o400_000

    # BUTTON4_DOUBLE_CLICKED
    B4DoubleClicked = 0o1_000_000

    # BUTTON4_TRIPLE_CLICKED
    B4TripleClicked = 0o2_000_000

    # B5: ???
    # TODO: Description for Button 5 on mouse
    # BUTTON5_RELEASED
    B5Released = 0o4_000_000

    # BUTTON5_PRESSED
    B5Pressed = 0o10_000_000

    # BUTTON5_CLICKED
    B5Clicked = 0o20_000_000

    # BUTTON5_DOUBLE_CLICKED
    B5DoubleClicked = 0o40_000_000

    # BUTTON5_TRIPLE_CLICKED
    B5TripleClicked =  0o100_000_000

    # Ctrl was pressed at the same time
    # BUTTON_CTRL
    Ctrl = 0o200_000_000

    # Shift was pressed at the same time
    # BUTTON_SHIFT
    Shift = 0o400_000_000

    # Alt was pressed at the same time
    Alt = 0o1_000_000_000

    # Should mouse coordinates be reported
    # TODO: Does this work?
    # REPORT_MOUSE_POSITION
    Position = 0o2_000_000_000

    # All mouse events (excl. position)
    # Use `Mouse::Position | Mouse::AllEvents` for both
    # ALL_MOUSE_EVENTS
    AllEvents = 0o1_777_777_777
  end
end
