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

The first argument is the object to send the message to, the second is a string
with the message name, and all following arguments are passed in as arguments with
that message.

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
