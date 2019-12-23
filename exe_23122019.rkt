#lang racket
;1) what are they evaluating to?

(* 2 (+ 4 5)); 18
(= 3 (+ 1 3)); #f
(car '(elmer fudd daffy duck)) ;'elmer
(cdr '(elmer fudd daffy duck)); '(fudd daffy duck)
(and (= 1 2) (= 10 (/ 1 0))); #f (lazy eval)

;; 2) find the squid

(define y '(clam squid octopus))
(cadr y)
(define z '(clam starfish (squid octopus) mollusc))
(caaddr z)

;; 3) define avg function

(define (my-avarage  lst )
  (let((x (apply + lst))) (/ x (length lst)) ))

;;or

(define (my-avarage-expli-rec lst)
    (define (f lst)
   (if (null? lst)
       0
   (+ (car lst)(f (cdr lst)) ) ))(/(f lst)(length lst))
    
  )

;; 4) define myMax function

(define (my-max lst)
  (if (null? lst)
      0
      (let ((x (car lst))) (if(>(my-max (cdr lst)) x) (my-max (cdr lst)) x))))

;; 7) tail recursive sum

(define (Tsum lst   accum)
  (if (null? lst)
      accum
      (Tsum (cdr lst)  (+ accum (car lst) ))))
;;8) Answer: 106 and 6 respectively. In the second expression, x in the second let overshadows the x in the first let.

;; 9) Define a function `mylength` to find the length of a list.
(define (my-length lst accum)
   (if (null? lst)
       accum
       (my-length (cdr lst) (+ 1 accum))))



;; worksheet two

;;1)

;(map list ’(1 2 3))
#|Answer: returns 3 lists, containing 1,2,3 respectively.
In genral, map applies the first argument, a procedure, sepratly to each member of the proceeding arguments |#

; (apply list ’(1 2 3))
#|Answer: creates one list, containing all 3 integers. In general, apply callse its first argumnet, a procedure, once, feeding to it as arguments,
all the subsequent arguments it received, following the procedure-argument, sliced in. |#

;;2)
;(filter even? ’(1 2 3 4 5))
;Answer: (2 4)
  
;(map even? ’(1 2 3 4 5))
;Answer: 5 lists (#f) (#t) (#f) (#t) (#f)
  
;(apply and ’(#t #f #t #f #t))
;Answer: #f, becasue AND requires all arguments to be #t.

;;3)

#|Answer: open and closed brackets indicate that you're asking racket to evaluate a procedure followed by at least one function, (odd?) contains no arguments!|#

;;4.1 & 4.2)

#|Define a function `make-counter`, which takes as input a *predicate*, and returns a function that takes a list and returns
the number of elements in the list satisfying that predicate.|#

(define (make-counter1 pred  ) (lambda (lst)
                                (letrec ([f (lambda (ls)
                                              (cond
                                                ((null? ls) 0)
                                                ((pred (car ls)) (+ 1 (f(cdr ls))))  
                                                ((not (pred (car ls))) (+ 0 (f(cdr ls))))
                                                ))
                                            ])
                                                  
                          (f lst) )
                                                 )
  )

 ;Show how to use `make-counter` to define `num-evens` in a concise manner.

(define (num-evens lst) ((make-counter1 even?)  lst))
(num-evens '(1 2 3))

;-----Or (using count)

 (define (make-counter2 pred  ) ( lambda (lst)
                                (if (null? lst) 0 (count pred lst))))

;----------works but not the solution
                                 (define (make-counter3 pred lst ) (define (f lst)
                                (cond [(null? lst) 0]
                               [ (pred (car lst)) (+ 1 (f (cdr lst)))]
                              [#t (+ 0 (f (cdr lst)))] ) ) (f lst) )

;;4.3) Show how to use `make-counter` to count the number of elements "greater than 5" in a list, without defining any intermediate names.

(define (>-5 lst)   ((make-counter1 (lambda (x) (< 5 x)))  lst))
(>-5 '(1 2 3 7))

;4.4)
#|In the same vein, write a function that takes a list of predicates, and returns a function that takes a list
and returns the number of elements in the list satisfying all of the predicates.|#

(define (satisfy-preds1 lst)   ((make-counter1 (lambda (x)  (andmap (lambda (p) (p x)) (list  odd? positive?) )  ) )  lst))
 (satisfy-preds1 '(1 2 3 4 5 0 -1))
;--------------Or
(define (satisfy-preds2 y lst)   ((make-counter1 (lambda (x)  (andmap (lambda (p) (p y x) ) (list  <) )  ) )  lst))
 (satisfy-preds2 5 '(1 2 3 4 5 0 -1 1 6 7))
;------------------Or
(define (satisfy-preds3 y lst)   ((make-counter1 (lambda (x)  (andmap (lambda (p)  (if (null? y) (p x) (p y x)))  (list  < <=) )  ) )  lst))
 (satisfy-preds3 null '(1 2 3 4 5 0 -1 1 6 7))
(satisfy-preds3 5 '(1 2 3 4 5 0 -1 1 6 7))
;-------------------Best
 (define (make-counter4 pred  ) (lambda (y lst)
           (letrec ([f (lambda (ls)
                         (cond
                           ((null? ls) 0)
                           ((andmap (lambda (p) (if (null? y) (p (car ls)) (p y (car ls)))) pred) (+ 1 (f(cdr ls))))  
                           ((not(andmap (lambda (p) (if (null? y) (p (car ls)) (p y (car ls))))pred)) (+ 0 (f(cdr ls))))
                           ))
                       ])  (f lst) ) ) )

            

(define (satisfy-pred-4-1 comparable args) ((make-counter4 (list = <=))comparable args ) )
(satisfy-pred-4-1  5 '(-1 0 1 2 3 4 5 6 7))
(define (satisfy-pred-4-2 comparable args) ((make-counter4 (list odd? positive?))comparable args ) )
(satisfy-pred-4-2  null '(-1 0 1 2 3 4 5 6 7))

;5.1)
#lang plai

#|
(factor? m n)
  m, n: positive natural numbers
  Returns #t if and only if m is a factor of n.
|#
(define (factor? m n)  
                       (cond
                         ((and (= m 0) (= n 0)) 0)
                         ((= m 0) #f)
                         ( #t (=(remainder n m)0))))

; Tests
  (test (factor? 2 6) #t)
  (test (factor? 1 6) #t)
  (test (factor? 6 2) #f)
  (test (factor? 3 10) #f)

#|
  n: positive natural number
  Returns a list of all factors of n, in increasing order.
|#

 (define (factors n)   (filter (lambda(x)  (factor? x n )) (range (+ n 1)))  )
  
; Tests
  (test (factors 5) '(1 5))
  (test (factors 12) '(1 2 3 4 6 12))
  (test (factors 1) '(1))

#|
(prime? n)
  n: positive natural number
  Returns #t if and only if n is prime.
|#


(define (prime? n)
  (if  (and (= (length (factors n))2) (= (car (factors n)) 1) (= (car (cdr (factors n))) n)) #t  #f))


; Tests
   (test (prime? 2) #t)
    (test (prime? 10) #f)
#|
(primes-up-to n)
  n: positive natural number
  Returns a list of all prime numbers up to and including n.
|#

(define (primes-up-to n) (filter prime?(range (+ n 1))))

; Tests
  (test (primes-up-to 20) '(2 3 5 7 11 13 17 19))


#| BONUS!
The above implementation we've guided you through is quite inefficient:
at every number, you calculate *all* of its factors.
Improve your algorithm for primes-up-to. :) 
|#
;COMMENT: not full solution as fastprime? doesn't stop as soon as it founds the first factor of n.
(define (fastprime? n)
  (if(or (= n 0) (= n 1)) #f
(if (= (foldr (lambda (y n) (if (and (factor? y n) (not (= y n))) y n)) n     (foldl cons null   (cddr(range (sqrt ( + 1 n)) ) ))) n) #t #f)))


   (test (fastprime? 2) #t)
    (test (fastprime? 10) #f)

(define (fast-primes-up-to n) (filter fastprime? (range (+ n 1))))

; Tests
    (test (fast-primes-up-to 20) '(2 3 5 7 11 13 17 19))




;; worksheet three

;;1) Define a function map2 that takes a two-argument function and two lists.
;It should return a list of the results of applying the function to corresponding pairs of elements from the two lists. For example,
(define (map2 fn lsta lstb)
 (if (equal? (length  lsta) (length  lstb)) (map fn lsta lstb)
      ((lambda f (if (> (length  lsta) (length  lstb)) (let ((lsa (take lsta (length  lstb)))) (map2 fn lsa lstb)) (let ((lsb (take lstb (length  lsta))))(map2 fn lsta lsb)) ))
     )))
; If the user passess lists of different lengths, the longer is truncated to match the shorter one to avoid errors or unexpected results.

;;2)What does the following expression evaluate to and why?
(let ((x 2))
     (let ((f (lambda (n) (+ x n))))
       (let ((x 17))
         (f 3))))
;Answer: 3 + 2 = 5, because the x of its own enviro, that is the x in the thrid let, isn't visable to f which is in the body of the first let.
;(let expressions only sees variables initialized in the environement from before the let expression)
;;What environment is (f 3) evaluated in?
;;Answer: in the enviro/body of the second let
;;What environment is the body of the lambda evaluated in?
;;Answer: in the enviro/body of the first let

;;3)What does the following expression evaluate to and why?
(define (addN n)
     (lambda (m) (+ m n)))
   (let* ((m 10)
          (n 20)
          (addit (addN 3)))
     (addit 100))
;;Answer; 103, because in line 5 of the program, invoking addN assigns a lambda to addit, containing already a value of 3, and executing that lambda, passing it 100,
; assigns 100 to m, adds it to n and return it.

;;4);What is the result of evaluating the following expression and why?
(let ((f (lambda () (/ 1 0)))
         (x (+ 3 4)))
 	(+ x x))
;;Answer: 14, because the body of a let does use all the variables defined in its var/expression pairs. This produces no division by zero excp because the lambda, f, is never executed

;;5)
(define-struct point3d ([x #:mutable] [y #:mutable] [z #:mutable]) #:transparent)
(define point (make-point3d 0 0 20) )
(point3d-z point)
(set-point3d-z!  point  10 )
point

;;6)
(define (make-cell)
   (let ((cell-content null))

     (define (get-value) cell-content)
     (define (set-value value)
              (set! cell-content value) )
     (define (dispatch m)
       (cond ((eq? m 'get-value) get-value)
             ((eq? m 'set-value) set-value)
              (else (error "Unknown request -- MAKE-CELL"  m))))
     dispatch))
 (define cell1 (make-cell))
((cell1 'get-value))
((cell1 'set-value) "red")
((cell1 'get-value))

;;7)
(define (make-point)
  
   (let ((x 0)
         (y 0))
     
     (define (get-value p)
       (cond ((eq? p 'x) x)
             ((eq? p 'y) y)
             (else (error "Unknown field -- GET-VALUE"  p))))
     
     (define (set-value p value)
       (cond ((eq? p 'x) (set! x value))
             ((eq? p 'y) (set! y value))
             (else (error "Unknown field -- SET-VALUE"  p))))
             
     (define (dispatch m)
       (cond ((eq? m 'get-value) get-value)
             ((eq? m 'set-value) set-value)
              (else (error "Unknown request -- MAKE-POINT"  m))))
     dispatch))
 (define point1 (make-point))
((point1 'get-value) 'x)
((point1 'get-value) 'y)
((point1 'set-value) 'x 5)
((point1 'set-value) 'y 10)
((point1 'get-value) 'x)
((point1 'get-value) 'y)
