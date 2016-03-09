# Reference

This is a reference of all the functions you can call by default in any Läsp
program.

## Special forms

### def

Defines a symbol in the global environment.

Parameters `(symbol value)`:

1. The name to refer to the value as a symbol (no other type is allowed).
2. The value to refer to, can be almost anything.

```clojure
(def five 5)
five ; => 5
```

You **can** redefine symbols at any time, which is especially handy when
playing around in the REPL, however you **should** in most cases only define
something once and treat it as a constant for all intents and purposes. To
create a local binding, use [let](#let) instead.


### fn

Creates a function.

Parameters `(parameters body)`:

1. A list of parameters that the function shall accept, e.g. `(arg1 arg2)`, `(one two & others)`, `(& args)`
2. The body of the function, the declared parameters will be available in here.

```clojure
; This creates a function object, it can be read as "a function of x".
(fn (x) (+ x 2)) ; => #<Fn (x)>

; Functions are called when placed as the first element in a form:
((fn (x) (+ x 2)) 40) ; => 42
```

Most of the time, you'll want to define a function before using it (see
[defn](#defn) for a nicer syntax for doing this):

```clojure
(def plus-two (fn (x) (+ x 2)))
(plus-two 40) ; => 42
```

Functions will enforce that the correct number of arguments is passed to them:

```clojure
; Here we pass 2 arguments to a 1-arity function, and we get an error:
(plus-two 40 41) ; !> Lasp::ArgumentError: wrong number of arguments (2 for 1)
```

#### Variadic parameter lists

Functions can also accept any number of extra arguments as a list:

```clojure
(def show-args
  (fn (one & others)
    (list one others)))

; All arguments after the fixed first one will be passed in as a list:
(show-args 1 2 3) ; => (1 (2 3))

; If only the arguments before the & are passed in, it will be an empty list:
(show-args 1) ; => (1 ())

; The arguments before the & are compulsory:
(show-args) ; !> Lasp::ArgumentError: wrong number of arguments (0 for 1+)
```

#### Ignoring parameters

Normally you get an error from naming 2 parameters the same, but if you want to
ignore parameters, the `_` is allowed to be used several times.

```clojure
(def ignore-2 (fn (nope nope) (println "lalalala"))) ; !> Lasp::SyntaxError
(def ignore-2 (fn (_ _)       (println "lalalala"))) ; => #<Fn (_ _)>
```


### do

Executes multiple forms in order and returns the result of the last one.
This is useful when you need to have a single form that does several things.

```clojure
; This form will both print "hello" and return 3:
(do (println "hello") (+ 1 2))
; hello
; => 3
```

### if

If the first form is truthy, evaluates the second form, otherwise it evaluates the third form.

Parameters `(test true-form false-form)`:

1. Always evaluated to test which form to proceed with.
2. Evaluated only when the first argument is truthy.
3. Evaluated only when the first argument is falsy.

```clojure
(if (= 1 1)
  "yep!"
  (println "not evaled!")) ; => "yep!"
```


### quote

Returns a form as is, without evaluating it.

```clojure
f               ; !> Lasp::NameError: f is not present in this context
(quote f)       ; => f
(quote (f 1 2)) ; => (f 1 2)

; Quote ignores any extra arguments
(quote f g)     ; => f
```

You can also use the shorthand syntax `'` to quote forms:

```clojure
'f       ; => f
'(f 1 2) ; => (f 1 2)
```

There is no difference between lists that you use to store data and the lists
that make up your program, therefore quoting a form and calling the
[`list`](#list) function have the same effect:

```clojure
(list 1 2 3) ; => (1 2 3)
'(1 2 3)     ; => (1 2 3)
```

These are both lists to start with, the difference is that the first one is
evaluated and the `list` function returns a list of its arguments, and the
second one is simply not evaluated and the list is returned as is.


### macro

Macros can restructure forms before they are evaluated - they work like
functions but accept their arguments before evaluation. Instead the result of
the macro is evaluated.

Functions:

1. Evaluate all the arguments in order.
2. Call the function with the arguments.
3. Return the result.

Macros:

1. Call the macro with the forms it was given as arguments.
2. Evaluate the return value of the macro.
3. Return the result.

```clojure
(def infix
  ; Accept arguments in natural order for maths operators
  (macro (form)
    ; Return a list of arguments in correct prefix-notation to be run
    (list (second form) (first form) (last form))))

; This will be restructured to `(+ 4 5)` before it is run.
(infix (4 + 5)) ; => 9
```

Except for the order of evaluation, macros behave just like functions and can
accept rest-arguments etc. the same way. Just like functions, you mostly want
to define them before you use them, see [defm](#defm).

**It is important to quote things that you do not want evaluated until after
the macro has returned.**

```clojure
; Note that we want `if` to be evaluated after the macro has returned, so we have to quote it.
(def reverse-if
  (macro (test false-form true-form)
    (list 'if test true-form false-form)))

(if true "yes" "no")         ; => "yes"
(reverse-if true "yes" "no") ; => "no"
```

To debug macros and see what they expand to without trying to evaluate the
result, see [macroexpand](#macroexpand).


### require

Loads and runs a Läsp file. Paths are relative to the folder where the `lasp`
command was invoked, or, if a second truthy parameter is passed, to the file
where `require` is called.

```clojure
(require "lasp_file.lasp")
(require "dir/lasp_file.lasp")
(require "../lasp_file.lasp")

; Pass a truthy second parameter to use relative paths:
(require "lasp_file.lasp" true)
(require "lasp_file.lasp" :relative)
```


## Core library

### +

Adds arguments in order.

```clojure
(+ 1 2 3) ; => 6
```


### -

Subtracts arguments in order.

```clojure
(- 1 2 3) ; => -4
```


### *

Multiplies arguments in order.

```clojure
(* 2 3 4) ; => 24
```


### /

Divides arguments in order.

```clojure
(/ 20 2 2) ; => 5
```


### <

Mandatory increasing order.

```clojure
(< 20 10)    ; => false
(< 10 11 12) ; => true
(< 10 11 10) ; => false
(< 10 10)    ; => false
```


### >

Mandatory decreasing order.

```clojure
(> 20 10)   ; => true
(> 10 9 8)  ; => true
(> 10 9 10) ; => false
(> 10 10)   ; => false
```


### =

Equality.

```clojure
(= 20 20 2)  ; => false
(= 20 20 20) ; => true
(= 20)       ; => true
```


### <=

Mandatory non-decreasing order.

```clojure
(<= 20 20 30) ; => true
(<= 20 20 10) ; => false
(<= 20 20)    ; => true
```


### >=

Mandatory non-increasing order.

```clojure
(>= 20 20 30) ; => false
(>= 20 20 10) ; => true
(>= 20 20)    ; => true
```


### list

Creates a list of all of its arguments.

```clojure
(list 1 2 3) ; => (1 2 3)

; Allows mixing arguments in any way
(list true nil :thing) ; => (true nil "thing")
```

See [head](#head), [tail](#tail) and [get](#get) for relevant operations (there
are many others too).

Instead of using `get`, lists also act as a function of their contents,
allowing for this syntax:

```clojure
(def my-list (list 32 42 6 9))
(my-list 1) ; => 42
```

### head

Gets the first item in a list, otherwise `nil`.

```clojure
(head (list 1 2 3)) ; => 1
(head (list))       ; => nil
```


### tail

Gets all items in a list except the first, when empty it returns an empty list.

```clojure
(tail (list 1 2 3)) ; => (2 3)
(tail (list))       ; => ()
```


### cons

Pushes an item onto the front of a list. Does **not** change the original list.

```clojure
(cons 1 (list 2 3)) ; => (1 2 3)
(cons 1 ())         ; => (1)
```


### dict

Creates a dictionary. The entries are given in pairs directly following each
other, you can use newlines to make this clearer. An uneven number of arguments
will produce an error.

```clojure
(dict :one 1 :two 2) ; => {"one" 1, "two" 2}

; Use whitespace to make the keys and values look paired together
(dict :one   1
      :two   2
      :three 3) ; => {"one" 1, "two" 2, "three" 3}

(dict :one 1 :two)   ; !> ArgumentError: odd number of arguments for Hash
```

See [get](#get), [assoc](#assoc) and [dissoc](#dissoc) for relevant operations.

Instead of using `get`, dicts also act as a function of their contents,
allowing for this syntax:

```clojure
(def my-dict (dict :seven 7))
(my-dict :seven) ; => 7
```


### get

Get item by id in a list or dict.

```clojure
(get 0 (list 1 2 3))              ; => 1
(get 3 (list 1 2 3))              ; => nil

(get :one (dict :one 1 :two 2))   ; => 1
(get :three (dict :one 1 :two 2)) ; => nil
```


### assoc

Add or change item in dict. Does **not** change the original dict.

```clojure
(assoc (dict) :one 1)        ; => {"one" 1}
(assoc (dict :one 1) :one 2) ; => {"one" 2}

; It does NOT change the original data structure
(def data (dict :one 1)) ; => {"one" 1}
(assoc data :one 2)      ; => {"one" 2}
data                     ; => {"one" 1}

; Works on lists too
(assoc (list 1 2 3) 1 5)    ; => (1 5 3)
(assoc (list 1 2 3) :one 1) ; !> TypeError: no implicit conversion of String into Integer
```


### dissoc

Remove item from dict. Does **not** change the original dict.

```clojure
(dissoc (dict :one 1 :two 2) :one) ; => {"two" 2}

; It does NOT change the original data structure
(def data (dict :one 1 :two 2)) ; => {"one" 1, "two" 2}
(dissoc data :one)              ; => {"two" 2}
data                            ; => {"one" 1, "two" 2}
```


### not

Returns the inverted truthiness of its argument.

```clojure
(not true)  ; => false
(not false) ; => true
(not nil)   ; => true
(not 1)     ; => false
```


### print

Prints its arguments to stdout and returns `nil`.

See also [println](#println) to print a line of output.

```clojure
(print "Hello ")
(print "world!\n") ; Manually add a newline
;; Hello world!

; It also takes several arguments and prints them after each other:
(print "Hello " "world!")
;; Hello world!
```


### readln

Reads one line of input from the terminal. Halts the program until a newline
has been received, the newline character will **not** be part of the returned
text.

```clojure
(def input (readln)) ; Will pause here until the user has entered something
```


### apply

Applies a function to a list of arguments as if they were passed in directly.

```clojure
(apply + (list 1 2 3)) ; => 6

; Equal to this:
(+ 1 2 3)
```


### send

Calls a Ruby method on an object.

Parameters `(message object & args)`:

1. The object to send the message to
2. A text with the message name
3. Any number of arguments to be passed along with the message

```clojure
(send :to_i "01011101" 2) ; => 93
```

```ruby
# Equal to this Ruby code:
"01011101".to_i(2)
```

You can accomplish the same by prepending a dot to the function name, this
makes it look very similar to a normal Läsp function call:

```clojure
(.upcase "hello") ; => "HELLO"
```


## Standard library

### first

Alias of [head](#head)


### rest

Alias of [tail](#tail)


### inc

Increments its argument by 1.

```clojure
(inc 5) ; => 6
```


### dec

Decrements its argument by 1.

```clojure
(dec 5) ; => 4
```


### nil?

Whether its argument is exactly `nil`.

```clojure
(nil? (list)) ; => false
(nil? false)  ; => false
(nil? nil)    ; => true
```


### empty?

Whether the given list is empty.

```clojure
(empty? (list 1)) ; => false
(empty? (list))   ; => true
```


### not=

Whether not all of the arguments are equal.

```clojure
(not= 2 2 3) ; => true
(not= 2 2 2) ; => false
```


### second

The second element in a list, otherwise `nil`.

```clojure
(second (list 1 2 3)) ; => 2
(second (list 1))     ; => nil
```


### mod

The remainder (or modulus) of the first argument divided by the second.

```clojure
(mod 38 7) ; => 3
```


### complement

Given a function, returns a function that returns the negated result of the given function.

```clojure
(def not-empty? (complement empty?))
(not-empty? (list 1)) ; => true
```


### even?

Whether a number is even.

```clojure
(even? 7) ; => false
(even? 4) ; => true
```


### odd?

Whether a number is odd.

```clojure
(odd? 7) ; => true
(odd? 4) ; => false
```


### zero?

Whether a number is zero.

```clojure
(zero? 0) ; => true
(zero? 1) ; => false
```


### len

The length of a list.

```clojure
(len (list 1 2 3 4 5)) ; => 5
```


### nth

Get item in list by index.

```clojure
(nth 2 (list 0 1 2 3 4)) ; => 2
```


### last

The last item in a list.

```clojure
(last (list 0 1 2 3 4)) ; => 4
```


### reverse

Reverse the order of a list.

```clojure
(reverse (list 1 2 3)) ; => (3 2 1)
```


### map

Map a function over every item in a list.

```clojure
(map inc (list 1 2 3)) ; => (2 3 4)
```


### reduce

Perform an operation over every item in a list, carrying the result.

Parameters `(func memo coll)`:

1. A 2-arity function taking a running total and the current item `(memo item)`.
   The result of this function is passed in as the `memo` the next invokation.
2. The initial value of `memo`.
3. The collection to reduce over.

Each item in the collection is passed to `func` along with the result of the
previous call.

```clojure
; Calculate the sum of a list
(reduce
  (fn (memo item) (+ memo item)) ; Add the running total (memo) to this item
  0                              ; Start counting from zero
  (list 1 2 3))                  ; These will all be passed in as `item` in turn
```

Note that `+` already is a function that takes 2 parameters and adds them
together, so this example can be shortened to just this (this is in fact
exactly how the [sum](#sum) method in the standard library is implemented):

```clojure
(reduce + 0 (list 1 2 3))
```


### filter

Returns a collection with all the items that returned true when passed to the
filter-function.

```clojure
(filter odd? (list 1 2 3)) ; => (1 3)
```


### sum

The sum of all items in a list.

```clojure
(sum (list 5 10 15)) ; => 30
```


### take

Take x items from the front of a list.

```clojure
(take 2 (list 1 2 3 4)) ; => (1 2)
```


### drop

Drop x items from the front of a list.

```clojure
(drop 2 (list 1 2 3 4)) ; => (3 4)
```


### range

A range of incrementing numbers from a to b-1.

```clojure
(range 0 10) ; => (0 1 2 3 4 5 6 7 8 9)
(range 10 0) ; => ()
```


### max

The highest value in a list.

```clojure
(max (list 4 6 1 5 3)) ; => 6
```


### min

The lowest value in a list.

```clojure
(min (list 4 6 1 5 3)) ; => 1
```

### every

Take a list of every Nth item in a list.

```clojure
(every 2 (list 1 2 3 4 5)) ; => (1 3 5)
(every 3 (list 1 2 3 4 5)) ; => (1 4)
```


### text

Create a string by concatenating all arguments.

```clojure
(text "one " 1 ", two " 2) ; => "one 1, two 2"
```


### text->list

Turn a text into a list of its characters.

```clojure
(text->list "abcdef") ; => ("a" "b" "c" "d" "e" "f")
```


### list->text

Turn a list into a text of its items.

```clojure
(list->text (list 1 2 3 4)) ; => "1234"
```


### ->text

Turn a value into text.

```clojure
(->text 5) ; => "5"
```


### ->integer

Turn a value into an integer.

```clojure
(->integer "5") ; => 5
(->integer 5.5) ; => 5
(->integer nil) ; => nil
```


### ->decimal

Turn a value into a decimal.

```clojure
(->decimal "5.5") ; => 5.5
(->decimal 5)     ; => 5.0
(->decimal nil)   ; => 0.0
```


### pipe

Pipe the first argument through a number of functions.

```clojure
(pipe 5 inc inc dec ->text) ; => "6"
```


### reverse-text

Reverse text.

```clojure
(reverse-text "hello") ; => "olleh"
```


### prompt

Request an answer to a question from a terminal user.

```clojure
(prompt "yes/no: ")
; The program halts waiting for the user, if she typed y and then pressed enter:
; => "y"
```


### println

Prints each of its arguments to stdout on a line and returns `nil`.

```clojure
(println "Hello World!")
;; Hello World!

(println "Hello " "World!")
;; Hello World!

(println) ; Prints a newline
```


### defn

A shorthand macro for defining a function. As a bonus it also wraps
body-arguments in a `do`-block.

```clojure
; These are equivalent

(def plus-two
  (fn (x)
    (do
      (println "doing stuff")
      (+ x 2))))

(defn plus-two
  (x)
  (println "doing stuff")
  (+ x 2))
```


### defm

A shorthand macro for defining a macro.

```clojure
; These are equivalent

(def infix
  (macro (form)
    (list (second form) (first form) (last form))))

(defm infix (form)
  (list (second form) (first form) (last form)))
```


### let

Creates local variable bindings.

Parameters `(bindings & body)`:

1. Any number of bindings consisting of a symbol directly followed by a value
   to bind it to. Declared in the same fashion as [dict](#dict) but with
   symbols instead of text.
2. The body in which the bindings are in scope.

Here `one` is bound to `1` and `two` is bound to `2`, they are available in the
body of the `let` and then go out of scope.

```clojure
; Here we put a newline after every pair to clarify their connection:
(let (one 1
      two 2)
  (+ one two)) ; => 3

; The bindings are no longer in scope.
one ; !> Lasp::NameError: one is not present in this context


; Bindings can be used directly in subsequent bindings
(let (one 1
      two (+ one 1))
  (+ one two)) ; => 3
```

If given an uneven number of bindings, the last one will be assigned to `nil`.

```clojure
(let (one 1 two 2 three) three) ; => nil
```


### or

Evaluates its arguments in turn, returning:

- the first **truthy** value it encounters
- the last value, if all forms evaluate to logical **false**
- `nil` if no arguments are given

```clojure
; Typical usage in if-statements
(or (= 1 2) (= 3 3)) ; => true
(or (= 1 2) (= 3 4)) ; => false

(or)               ; => nil
(or nil nil false) ; => false

; will return without printing anything
(or (not true) 42 (println "nope")) ; => 42
```


### and

Evaluates its arguments in turn, returning:

- the first **falsy** value it encounters
- the last value, if all forms evaluate to logical **true**
- `true` if no arguments are given

```clojure
; Typical usage in if-statements
(and (= 1 1) (= 2 2)) ; => true
(and (= 1 1) (= 2 3)) ; => false

(and)               ; => nil
(and true true 42)  ; => 42

; will return without printing anything
(and 42 false (println "nope")) ; => false
```



### macroexpand

Returns the unevaluated result of a macro, indispensable for debugging.

```clojure
(defm infix (form)
  (list (second form) (first form) (last form)))

(infix (4 + 5))               ; => 9
(macroexpand (infix (4 + 5))) ; => (+ 4 5)
```
