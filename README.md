# Läsp [![Build Status](https://travis-ci.org/alcesleo/lasp.svg?branch=master)](https://travis-ci.org/alcesleo/lasp)

A Lisp implementation in Ruby.

## Features

- Very concise [core library](lib/lasp/corelib.rb) written in Ruby
- [Standard library](lib/lasp/stdlib.lisp) written in Läsp itself
- Interactive REPL with auto-closing of missing trailing parentheses
- Fully functional macro system
- Interoperability with Ruby

## Installation

It needs Ruby to work, on Mac or most Linux OS:s it's already there and you can simply

```bash
gem install lasp

# If it doesn't work you might need to sudo
sudo gem install lasp

# You can update to the latest version the same way:
gem update lasp
sudo gem update lasp
```

## Running

After installing you can invoke `lasp` for a REPL or provide a lasp-file to execute.

```bash
# An interactive prompt that lets you play with the language
lasp

# Run lasp-files
lasp path/to/program.lasp
```

## The language

Please reference the [documentation](DOCUMENTATION.md) for specific definitions
and examples of all available functions.

### Examples

More advanced examples can be found in [EXAMPLES.md](EXAMPLES.md), you can also
look at the [standard library](lib/lasp/stdlib.lasp) which is implemented in
Läsp itself.

```lisp
(+ 1 2 3) ;; => 6

(def x 5)
x ;; => 6

(sum (list 5 10 15)) ;; => 30

(def inc (fn (x) (+ x 1)))
(inc 5) ;; => 6
```


### Comments

Comments start with a `;` and end at the end of a line

```lisp
; This is a comment
(+ 1 2) ; This is also a comment
```

## Developing

### Run the specs

```bash
bundle exec rake
```

### Dev REPL

```bash
# This is basically just a shorthand for `rake install && lasp`
rake repl
```
