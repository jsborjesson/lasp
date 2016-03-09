# Läsp [![Build Status](https://travis-ci.org/alcesleo/lasp.svg?branch=master)](https://travis-ci.org/alcesleo/lasp)

A Lisp implementation in Ruby.

## Features

- Comprehensive [documentation](#documentation)
- Interactive REPL with auto-closing of missing trailing parentheses
- Closures
- let-bindings
- Fully functional macro system
- Interoperability with Ruby
- Very concise [core library](lib/lasp/corelib.rb) written in Ruby
- [Standard library](lib/lasp/stdlib.lasp) written in Läsp itself

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

## Documentation

- [Language](docs/language.md) - explains the core types and syntax of the language.
- [Reference](docs/reference.md) - a list of every available function with description and usage examples.
- [Examples](docs/examples.md) - various small examples of using the language.


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
