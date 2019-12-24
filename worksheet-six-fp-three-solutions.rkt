#lang racket
;; worksheet three

;;1)
#|Define a function map2 that takes a two-argument function and two lists.
It should return a list of the results of applying the function to corresponding pairs of elements from the two lists.|#

(define (map2 fn lsta lstb)
 (if (equal? (length  lsta) (length  lstb)) (map fn lsta lstb)
      ((lambda f (if (> (length  lsta) (length  lstb)) (let ((lsa (take lsta (length  lstb)))) (map2 fn lsa lstb)) (let ((lsb (take lstb (length  lsta))))(map2 fn lsta lsb)) ))
     )))
;JUSTIFICATION If the user passess lists of different lengths, the longer is truncated to match the shorter one to avoid errors or unexpected results.

;;2)What does the following expression evaluate to and why?
(let ((x 2))
     (let ((f (lambda (n) (+ x n))))
       (let ((x 17))
         (f 3))))

#|Answer: 3 + 2 = 5, because the x of its own enviro, that is the x in the thrid let, isn't visable to f which is in the body of the first let.
(let expressions only sees variables initialized in the environement from before the let expression)|#

;;2.1 What environment is (f 3) evaluated in?
;;Answer: in the enviro/body of the second let

;;2.3 What environment is the body of the lambda evaluated in?
;;Answer: in the enviro/body of the first let

;;3)What does the following expression evaluate to and why?
(define (addN n)
     (lambda (m) (+ m n)))
   (let* ((m 10)
          (n 20)
          (addit (addN 3)))
     (addit 100))
#|Answer; 103, because in line 5 of the program, invoking addN assigns a lambda to addit, containing already a value of 3,
and executing that lambda, passing it 100, assigns 100 to m, adds it to n and return it.|#

;;4);What is the result of evaluating the following expression and why?
(let ((f (lambda () (/ 1 0)))
         (x (+ 3 4)))
 	(+ x x))
#|Answer: 14, because the body of a let does use all the variables defined in its var/expression pairs.
This produces no division by zero excp because the lambda, f, is never executed|#

;;5)Define a struct called point3d that represents 3D points.
(define-struct point3d ([x #:mutable] [y #:mutable] [z #:mutable]) #:transparent)
(define point (make-point3d 0 0 20) )
(point3d-z point)
(set-point3d-z!  point  10 )
point

;;6) Define a make-cell function
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

;;7)Similarly but with more bells and whistles... 
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
