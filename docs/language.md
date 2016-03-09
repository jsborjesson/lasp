# Language

This page describes the syntax and core types of the language.

## Data types

The core types are backed by their corresponding Ruby classes. This can be seen
by doing `(.class 5)`.

### integer

A whole number.

```clojure
1
-42
0
```

### decimal

A decimal number.

```clojure
3.56
-0.5
```

### boolean

The value `true` or `false`.

```clojure
true
false
```

### nil

The "null" or "no value" type.

```clojure
nil
```

### text

Text of any length. There is a shorthand syntax that can be used when the
string does not contain any whitespace - this makes the syntax in `dict`s
nicer, for example.

It supports these escape characters:

- `\n` - a newline
- `\t` - a tab
- `\\` - a literal `\`
- `\"` - a literal `"`

```clojure
"some text" ; => "some text"

; Shorthand version
:text ; => "text"

; Using escape characters
;
; Note that they will still look escaped when returned in the REPL,
; however, if you print them you will get the literal text.
"text with \" and \\ in it" ; => "text with \" and \\ in it"

(println "text with \" and \\ in it")
; text with " and \ in it
```

### list

A heterogeneous (allows mixed types) list of values, can be created with the
[list](#docs/reference.md#list) function. This type is also used to call a
function. There is no difference between a list of data and a "list of code",
a.k.a. **form**.

```clojure
(list 1 2 :three) ; => (1 2 "three")

; The first item in the list will be called with the rest of the list as arguments:
(println "Hello, " "world!")
```

### dict

A dictionary (a.k.a. hash-map) of keys that map to values, can be created with
the [dict](docs/reference.md#dict) function.

```clojure
; Here we use the shorthand text syntax as keys
(dict :one 1 :two 2) ; => {"one" 1, "two" 2}
```

### symbol
Used to name other things (see [def](#def)), but can be obtained in itself by quoting (see [quote](#quote))

```clojure
; A symbol will resolve to what it has been defined as
symbol

; To obtain a symbol by itself, you have to quote it
'symbol
```

## Ruby interoperability

You can access Ruby classes and modules, to access nested ones use `/`. To call Ruby methods, simply prepend a dot to the method name, and pass the object as the first parameter.

```clojure
(.ceil Math/PI)
```
