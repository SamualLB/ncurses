lib LibNCurses
  # Attributes that can be added to change text appearence
  enum Attribute : LibC::UInt
    # Reset all attributes
    Normal     =              0o0

    # Extract color pair
    Color      =        0o177_400

    # Highlight
    Standout   =        0o200_000

    # Underline text
    Underline  =        0o400_000

    # Reverse colors (fg & bg)
    Reverse    =      0o1_000_000

    # Blinking text
    Blink      =      0o2_000_000

    # Half bright
    Dim        =      0o4_000_000

    # Extra bright or bold
    Bold       =     0o10_000_000

    # Alternate character set
    AltCharSet =     0o20_000_000

    # Invisible
    Invisible  =     0o40_000_000

    # Protective mode
    Protect    =    0o100_000_000

    # Horizontal highlight
    Horizontal =    0o200_000_000

    # Left highlight
    Left       =    0o400_000_000

    # Low highlight
    Low        =  0o1_000_000_000

    # Right highlight
    Right      =  0o2_000_000_000

    # Top highlight
    Top        =  0o4_000_000_000

    # Vertical highlight
    Vertical   = 0o10_000_000_000

    # Italic text ???
    # TODO: check if this works as it is i32.max + 1
    Italic     = 0o20_000_000_000

    # Extract attributes
    # TODO: check if this works as it is > i32.max
    Attributes = 0o37_777_777_400
  end
end
