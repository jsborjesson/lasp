# Documentation

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
