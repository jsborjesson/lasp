# Läsp changelog

## v0.5.0

- Merge `lasp-repl` command into `lasp`, it starts when not provided with a filename.
- Don't send env to functions implemented as Ruby procs, it was never used.
- Specs as default rake task.

## v0.4.0

Implicit do-blocks around files. You can now do this...:

```lisp
(def x 5)

(def y 10)
```

...in a Läsp file without having to wrap the entire contents of the file in
`(do ...)`. Previously it just stopped reading after the first form and
anything after would seemingly inexplicably not be run.

**This is only enabled in files, not every form of evaluation.**

## v0.3.2

Fix bug in `do` - it accidentally returned part of the AST, now it correctly
returns the result of the last expression.

## v0.3.1

Make readline support actually work once released to rubygems by implementing it directly in Ruby.

It does not seem to remember history between runs like rlwrap did, but trying
to deploy an interactive bash script to rubygems is just too much of a headache
and this is almost as nice with just a single line of Ruby.

## v0.3.0

Add readline support in the REPL using rlwrap, this makes the REPL a **lot** nicer to use.

## v0.2.0

Add support for hash-maps with the following added functions to the core library:

- `hash-map`
- `get`
- `assoc`
- `dissoc`

Also adds exit instructions to the REPL welcome message.

## v0.1.1

Fix broken `lasp` executable.

## v0.1.0

First release.
