# Läsp

A very simple Lisp implementation in Ruby. Run `lasp-repl` to play around with it.

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

## Methods in core lib

- `+`
- `-`
- `*`
- `/`
- `=`
- `def`
- `fn`
- `head`
- `tail`
- `cons`

## Developing

Run the tests with `rspec`.
