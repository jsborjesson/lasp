# Läsp

A very simple Lisp implementation in Ruby. Run `lasp-repl` to play around with
it, or `lasp path/to/program.lasp` to execute a Läsp file.

## Examples

```lisp
(+ 1 2 3)
# => 6

(def x 5)
x
# => 6

(def inc (fn (x) (+ x 1)))
(inc 5)
# => 6
```

## Functions in corelib (ruby)

- `+`
- `-`
- `*`
- `/`
- `=`
- `head`
- `tail`
- `cons`
- `println`

## Special forms

- `def`
- `fn`
- `begin`

## Developing

Run the tests with `rspec`.
