lib LibNCurses
  # Special keys recovered when using `NCurses#keypad(true)`
  # 
  # Contains all F keys from 0 to 63
  enum Key : LibC::Int
    # Required 2 inputs, do not use normally
    Esc = 27

    # Capital A
    # TODO: Find a macro to generate all letters
    UpperA = 65
    LowerA = 97

    # KEY_DOWN
    Down = 0o402

    # KEY_UP
    Up = 0o403

    # KEY_LEFT
    Left = 0o404

    # KEY_RIGHT
    Right = 0o405

    # KEY_HOME
    Home = 0o406

    # KEY_BACKSPACE
    Backspace = 0o407

    # F0 to F63
    {% for n in (0...64) %}
      F{{n}} = 0o410 + {{n}}
    {% end %}

    # KEY_DL
    Delete = 0o512

    # KEY_IC
    Insert = 0o513

    # KEY_SF
    # Shift + Down
    ShiftDown = 0o520

    # KEY_SR
    # Shift + Up
    ShiftUp = 0o521

    # KEY_NPAGE
    PageDown = 0o522

    # KEY_PPAGE
    PageUp = 0o523

    # KEY_ENTER
    Enter = 0o527

    # KEY_BTAB
    # Shift + Tab
    ShiftTab = 0o541

    # KEY_END
    End = 0o550

    # KEY_SDC
    # Shift + Delete
    ShiftDelete = 0o577

    # KEY_SEND
    # Shift + End
    ShiftEnd = 0o602

    # KEY_SHOME
    # Shift + Home
    ShiftHome = 0o607

    # KEY_SLEFT
    # Shift + Left
    ShiftLeft = 0o611

    # KEY_SNEXT
    # Shift + PageDown
    ShiftPageDown = 0o614

    # KEY_SPREVIOUS
    # Shift + PageUp
    ShiftPageUp = 0o616

    # KEY_SRIGHT
    ShiftRight = 0o622

    # KEY_MOUSE
    # If any mouse request mouse input was detected
    # Retrieve actual date with `NCurses#get_mouse`
    Mouse = 0o631

    # KEY_RESIZE
    # If the terminal has been resized
    Resize = 0o632
  end
end
