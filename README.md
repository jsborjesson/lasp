# Läsp

A very simple Lisp implementation in Ruby. Run `lasp-repl` to play around with
it, or `lasp path/to/program.lasp` to execute a Läsp file.

## The language

### Examples

```lisp
(+ 1 2 3)
; => 6

(def x 5)
x
; => 6

(def inc (fn (x) (+ x 1)))
(inc 5)
; => 6
```

### Data types

Supports these datatypes (implemented as their Ruby counterparts)

- integer
- float
- boolean
- nil
- string

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
- `=`
- `head`
- `tail`
- `cons`
- `not`
- `println`

### Special forms

Implemented as special cases while evaluating.

- `def`
- `fn`
- `begin`
- `if`

### Functions in stdlib

Implemented in Läsp itself.

- `first` (alias of `head`)
- `rest` (alias of `tail`)
- `inc`
- `empty?`
- `len`
- `nth`
- `map`
- `reduce`
- `sum`

## Developing

Run the tests with `rspec`.
