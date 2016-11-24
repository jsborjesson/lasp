# laspec

A simple RSpec clone written in Läsp.

## Writing a test

```lisp
(require "laspec.lasp")

(describe "parser"
  (it "one equals one"
    (expect-eq 1 1))

  (it "one equals two"
    (expect-eq 1 2)))
```

## Running tests

Simply run the file like a normal lasp file

```bash
$ lasp example_spec.lasp
.F

Total tests: 2
Passed tests: 1

Failures:

FAIL: one equals two - Expected 1, got 2
```
