# Examples

```lisp
; Notes:
;
; A complete list of the available functions can be found in the README.
;
; Since Läsp is very similar to Clojure, you can get pretty decent syntax
; highlighting by just setting your editor to treat .lasp files as .clj
;
; In this document output is shown with ;; and normal comments with ;.

; Number types
1
1.5

; Booleans and nil
true
false
nil

; Strings
"hello world!"
:hey ; Symbol-style string (not its own type)

; Lists
(list 1 2 3) ;; => [1, 2, 3]
(list)       ;; => []

; Basic function call
; inc is a function that increments its argument, and 1 is the single argument
(inc 1) ;; => 2

; Simple maths functions takes any number of arguments
(/ 20 2)     ;; => 10
(+ 1 3 5)    ;; => 9
(* 2 5 6 10) ;; => 600

; Equality operators also do
(= 1 5)     ;; => false
(= 3 3 3)   ;; => true
(> 3 2 1 0) ;; => true

; Boolean inversion
(not true) ;; => false

; List operations

(head (list 1 2 3))  ;; => 1
(first (list 1 2 3)) ;; => 1

(tail (list 1 2 3)) ;; => [2, 3]
(rest (list 1 2 3)) ;; => [2, 3]

(cons 0 (list 1 2 3)) ;; => [0, 1, 2, 3]

(nth 1 (list 1 2 3)) ;; => 2
(nth 3 (list 1 2 3)) ;; => nil

(last (list 1 2 3)) ;; => 3

(take 2 (list 1 2 3)) ;; => [1, 2]
(drop 2 (list 1 2 3)) ;; => [3]

(max (list 1 3 2)) ;; => 3

(reverse (list 1 2 3)) ;; => [3, 2, 1]

; Ranges
(range 1 10) ;; => [1, 2, 3, 4, 5, 6, 7, 8, 9]

; Apply a function to all items in a list
(map inc (list 1 2 3)) ;; => [2, 3, 4]

; Accumulate a value with a function
; The function (here +) will receive a memo (the running total)
; and each item in the list in order. The 0 is the starting value
(reduce + 0 (list 1 2 3)) ;; => 6

; This is how sum is implemented
(sum (list 1 2 3)) ;; => 6

; The starting value is important.
(reduce * 1 (list 1 2 3)) ;; => 6

; Filtering
(filter odd? (list 1 2 3)) ;; => [1, 3]

; Variables
(def x (list 1 2 3)) ;; => [1, 2, 3]
x                    ;; => [1, 2, 3]

; Outputting to the terminal
(println "hello world!")
;; hello world!
;; => nil

; If
(if (< 4.9 5)
  (println "yep!")
  (println "nope!"))
;; yep!
;; => nil

(if (< 5.1 5)
  (println "yep!")
  (println "nope!"))
;; nope!
;; => nil

; Functions
; A function has 2 forms, one with the parameters and one with the body.
; Here's a function that adds 10 to its argument
(fn (x) (+ 10 x))

; You can call it just like one of the named functions
((fn (x) (+ 10 x)) 50) ;; => 60

; You can give it a name yourself
(def add-ten (fn (x) (+ 10 x)))
(add-ten 50) ;; => 60

; Ruby interop
(. (list 1 2 3) :)
```
