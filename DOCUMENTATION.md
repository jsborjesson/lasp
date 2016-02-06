# Documentation

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


### fn

Creates a function.

Parameters `(parameters body)`

1. A list of parameters that the function shall accept, e.g. `(arg1 arg2)`, `(one two & others)`, `(& args)`
2. The body of the function, the declared parameters will be available in here.

```clojure
; This creates a function object, it can be read as "a function of x".
(fn (x) (+ x 2)) ; => #<Fn (x)>

; Functions are called when placed as the first item in a form:
((fn (x) (+ x 2)) 40) ; => 42
```

Most of the time, you'll want to define a function before using it (see [defn](#defn)):

```clojure
(def plus-two (fn (x) (+ x 2)))
(plus-two 40) ; => 42
```

Functions will enforce that the correct number of arguments is passed to them:

```clojure
; Here we pass 2 arguments to a 1-arity function, and we get an error:
(plus-two 40 41) ; !> Lasp::ArgumentError: wrong number of arguments (2 for 1)
```

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
f               ; !> KeyError: key not found: f
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

To debug macros and see what they expand to without trying to evaluate the result, see [macroexpand](#macroexpand).


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

Creates a dictionary.

```clojure
(dict :one 1 :two 2) ; => {"one" 1, "two" 2}
(dict :one 1 :two)   ; !> ArgumentError: odd number of arguments for Hash
```


### get

Get item by id in a list or dict.

```clojure
(get 0 (list 1 2 3))            ; => 1
(get :one (dict :one 1 :two 2)) ; => 1
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


### println

Prints its argument to stdout and returns `nil`.

```clojure
(println "Hello World!") ; => nil
;; Hello World!
```


### apply

Applies a function to a list of arguments as if they were passed in directly.

```clojure
(apply + (list 1 2 3)) ; => 6

; Equal to this:
(+ 1 2 3)
```


### .

Interoperability operator - calls a Ruby method.

Parameters `(object message & args)`:

1. The object to send the message to
2. A string with the message name
3. Any number of arguments to be passed along with the message

```clojure
(. "01011101" :to_i 2) ; => 93
```

```ruby
# Equal to this Ruby code:
"01011101".to_i(2)
```


### require

Loads and runs a Läsp file.

```clojure
(require "./path/to/lasp_file.lasp")
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

Parameters `(func acc coll)`:

1. A 2-arity function taking `(accumulator item)`
2. The initial value of the accumulator
3. The collection to reduce over

Each item in the collection is passed to `func` along with the result of the
previous call as `accumulator`.

```clojure
(reduce + 0 (list 1 2 3)) ; => 6
(reduce * 1 (list 5 10)) ; => 50
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

The lowest value in a list

```clojure
(min (list 4 6 1 5 3)) ; => 1
```


### str->list

Turn a string into a list of its characters.

```clojure
(str->list "abcdef") ; => ("a" "b" "c" "d" "e" "f")
```


### list->str

Turn a list into a string of its items.

```clojure
(list->str (list 1 2 3 4)) ; => "1234"
```


### ->str

Turn a value into a string.

```clojure
(->str 5) ; => "5"
```


### pipe

Pipe the first argument through a number of functions.

```clojure
(pipe 5 inc inc dec ->str) ; => "6"
```


### reverse-str

Reverse a string.

```clojure
(reverse-str "hello") ; => "olleh"
```


### defn

A shorthand macro for defining a function. As a bonus it also wraps
body-arguments in a `do`-block.

```clojure
; These are equivalent

(def plus-two
  (fn (x)
    (do
      (+ x 2))))

(defn plus-two
  (x)
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


### macroexpand

Returns the unevaluated result of a macro, indispensable for debugging.

```clojure
(defm infix (form)
  (list (second form) (first form) (last form)))

(infix (4 + 5))               ; => 9
(macroexpand (infix (4 + 5))) ; => (+ 4 5)
```
