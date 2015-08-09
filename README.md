# Läsp

A very simple programming language implemented in Ruby.

It is just a toy Lisp implementation and should not be used seriously by anyone.

## Installation

It needs Ruby to work, on Mac or most Linux OS:s it's already there and you can simply

```bash
gem install lasp

# If it doesn't work you might need to sudo
sudo gem install lasp
```

## Running

After installing there are two commands available to you:

```bash
# An interactive prompt that lets you play with the language
lasp-repl

# Run lasp-files
lasp path/to/program.lasp
```

It is highly recommended that you also install rlwrap (`brew install rlwrap`),
this gives the repl readline support and makes it **much** nicer to use.

## The language

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

### Data types

Supports these datatypes (implemented as their Ruby counterparts)

- integer
- float
- boolean
- nil
- string
- list

### Comments

Comments start with a `;` and end at the end of a line

```lisp
; This is a comment
(+ 1 2) ; This is also a comment
```

### Functions in corelib

Implemented as Ruby lambdas.

- `+`
- `-`
- `*`
- `/`
- `<`
- `>`
- `=`
- `list`
- `head`
- `tail`
- `cons`
- `hash-map`
- `get`
- `assoc`
- `dissoc`
- `not`
- `println`
- `.`

### Special forms

Implemented as special cases while evaluating.

- `def`
- `fn`
- `do`
- `if`

### Functions in stdlib

Implemented in Läsp itself.

- `first` (alias of `head`)
- `rest` (alias of `tail`)
- `inc`
- `dec`
- `empty?`
- `mod`
- `complement`
- `even?`
- `odd?`
- `len`
- `nth`
- `last`
- `reverse`
- `map`
- `reduce`
- `filter`
- `sum`
- `take`
- `drop`
- `range`
- `max`
- `min`

## Developing

### Run the specs

```bash
rspec

# or more verbose
rspec --format=documentation
```

### Dev REPL

```bash
# This is basically just a shorthand for `rake install && lasp-repl`
rake repl
```
