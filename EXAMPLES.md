# Examples

A complete list of the available functions can be found in the README.

Since Läsp is very similar to Clojure, you can get pretty decent syntax
highlighting by just setting your editor to treat .lasp files as .clj

In this document output is shown with ;; and normal comments with ;.

## Data types

```lisp
; Number types
1
1.5

; Booleans and nil
true
false
nil

; Strings
"hello world!" ;; => "hello world!"

; Symbol-style strings (not its own type)
:hey ;; => "hey"

; Lists
(list 1 2 3) ;; => [1, 2, 3]
(list)       ;; => []
```

## Basic function calls

```lisp
; inc is a function that increments its argument, and 1 is the single argument
(inc 1) ;; => 2

; Outputting to the terminal
(println "hello world!")
;; hello world!
;; => nil

; Simple maths functions take any number of arguments
(/ 20 2)     ;; => 10
(+ 1 3 5)    ;; => 9
(* 2 5 6 10) ;; => 600

; Equality operators also do
(= 1 5)     ;; => false
(= 3 3 3)   ;; => true
(> 3 2 1 0) ;; => true

; Boolean inversion
(not true) ;; => false
```

## List operations

```lisp
(head (list 1 2 3))  ;; => 1
(first (list 1 2 3)) ;; => 1

(tail (list 1 2 3)) ;; => (2 3)
(rest (list 1 2 3)) ;; => (2 3)

(cons 0 (list 1 2 3)) ;; => (0 1 2 3)

(nth 1 (list 1 2 3)) ;; => 2
(nth 3 (list 1 2 3)) ;; => nil

; get does the same as nth on lists (although implemented differently)
(get 1 (list 1 2 3)) ;; => 2
(get 3 (list 1 2 3)) ;; => nil

; assoc returns a new array with the specified index updated
(assoc (list 1 2 3) 0 "one") ;; => ("one" 2 3)

(last (list 1 2 3)) ;; => 3

(take 2 (list 1 2 3)) ;; => (1 2)
(drop 2 (list 1 2 3)) ;; => (3)

(max (list 1 3 2)) ;; => 3

(reverse (list 1 2 3)) ;; => (3 2 1)

; Ranges
(range 1 10) ;; => (1 2 3 4 5 6 7 8 9)
```

## Dictionaries

```lisp
; Create a dict
(dict :one 1 :two 2) ;; => {"one" 1, "two" 2}

; get also works with dicts
(get :one (dict :one 1 :two 2)) ;; => 1

; assoc works with dicts too
(assoc (dict :one 1 :two 2) :three 3) ;; => {"one" 1, "two" 2, "three" 3}

; dissoc removes values
(dissoc (dict :one 1 :two 2) :one) ;; => {"two" 2}
```

## More complex functions

```lisp
; Apply a function to all items in a list
(map inc (list 1 2 3)) ;; => (2 3 4)

; Accumulate a value with a function
; The function (here +) will receive a memo (the running total)
; and each item in the list in order. The 0 is the starting value
(reduce + 0 (list 1 2 3)) ;; => 6

; This is how sum is implemented
(sum (list 1 2 3)) ;; => 6

; The starting value is important.
(reduce * 1 (list 1 2 3)) ;; => 6

; Filtering
(filter odd? (list 1 2 3)) ;; => (1 3)
```

## Variables

```lisp
; Define and evaluate a variable
(def x (list 1 2 3))
x ;; => (1 2 3)

; Use it in a function
(sum x) ;; => 6
```

## If

```lisp
(if (< 4.9 5)
  "under"
  "over")
;; => "under"

(if (< 5.1 5)
  (println "yep!")
  (println "nope!"))
;; nope!
;; => nil
```

## Creating functions

```lisp
; A function has 2 forms, one with the parameters and one with the body.
; Here's a function that adds 10 to its argument
(fn (x) (+ 10 x))

; You can call it just like one of the named functions by placing the entire
; fn-form at the first position
((fn (x) (+ 10 x)) 50) ;; => 60

; You can give it a name by defining it
(def add-ten (fn (x) (+ 10 x)))
(add-ten 50) ;; => 60

(def square (fn (x) (* x x)))
(square 5) ;; => 25

; Arity is enforced when calling a function, this yields an error:
(square 5 2) ;; !> wrong number of arguments (2 for 1)


; Rest arguments are passed in as a list to the binding after the &
(def last-argument
  (fn (& args)
    (last args)))

(last-argument 1 2)   ;; => 2
(last-argument 1 2 3) ;; => 3

; You can also have mandatory positional arguments and rest arguments at the same time
(def add-first-two
  (fn (a b & args)
    (+ a b)))

(add-first-two 1 2)   ;; => 3
(add-first-two 1 2 3) ;; => 3
(add-first-two 1)     ;; !> wrong number of arguments (1 for 2+)
```

### Count the amount of 5:s in a list

```lisp
; The list we will operate on
(def fives (list 1 5 2 3 5 8 5)) ; 5 occurs 3 times.

(reduce        ; Reduce takes a function(1), a starting value(2) and a list(3).
  (fn (acc x)  ; (1) The function in turn takes an accumulator and an item in the list.
    (if (= x 5)  ; If the item is five:
      (inc acc)  ; We increment the accumulator and move on to the next item.
      acc))      ; Otherwise we return the total as is.
  0            ; (2) We start counting from 0
  fives)       ; (3) We operate over the previously defined `fives` list.
;; => 3
```

### Print a beautiful pyramid

```lisp
; Print one row in the pyramid
(def print-row
  (fn (length)
    (println (* "#" length)))) ; We use the fact that the host platform (Ruby) can multiply strings

; Print the entire pyramid
(def print-pyramid
  (fn (height current-width)
    (if (= current-width height)
      nil
      (do
        (print-row current-width)
        (print-pyramid height (inc current-width))))))

; Do it!
(print-pyramid 10 1)
;; #
;; ##
;; ###
;; ####
;; #####
;; ######
;; #######
;; ########
;; #########
```

## Interoperability

```lisp
; The . function allows for Ruby interoperability.
(. "01011101" :to_i 2) ;; => 93

(def parse_binary (fn (bin) (. bin :to_i 2)))
(parse_binary "01011101") ;; => 93
```
