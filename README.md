[![Build Status](https://travis-ci.com/SamualLB/ncurses.svg?branch=master)](https://travis-ci.com/SamualLB/ncurses)
# ncurses

Ncurses Bindings for Crystal

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  ncurses:
    github: SamualLB/ncurses
```


## Usage


```crystal
require "ncurses"
```

#### Basic Printing

```crystal
NCurses.init

NCurses.stdscr.print "Hello world!"

NCurses.end_win
```

#### Run Examples

```text
$ crystal run examples/input.cr
```
```text
$ crystal run examples/attributes.cr
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
