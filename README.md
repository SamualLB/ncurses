[![Build Status](https://travis-ci.com/SamualLB/ncurses.svg?branch=master)](https://travis-ci.com/SamualLB/ncurses)
# ncurses

Ncurses Bindings for Crystal

## Installation

1. Add this to your application's `shard.yml`:

```yaml
dependencies:
  ncurses:
    github: SamualLB/ncurses
```

2. Run `shards install`

**NOTE**: You may need to install the wide ncurses development library `libncursesw5-dev` (Debian)

## Usage


```crystal
require "ncurses"
```

#### Basic Printing

```crystal
NCurses.start

NCurses.print "Hello world!"

NCurses.end
```

#### Run Examples

Prints input
```text
$ crystal run examples/input.cr
```

Displays text with attributes
```text
$ crystal run examples/attributes.cr
```

Displays text with colors
```text
$ crystal run examples/colors.cr
```

Shows separate windows
```text
$ crystal run examples/windows.cr
```

Mouse interaction with individual windows
```text
$ crystal run examples/window_enclose.cr
```

Scroll when overflowing window
```text
$ crystal run examples/scroll.cr
```


## Contributing

1. Fork it ( https://github.com/SamualLB/ncurses.git )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- (https://github.com/jreinert) Joakim Reinert - creator, maintainer
- (https://github.com/SamualLB) Samual Black - maintainer
