# Worksheet on Functional Programming

## The third worksheet on Racket

These questions deal with structs, representing objects, and lexical scoping.

1. Define a function `map2` that takes a two-argument function and two lists. 
It should return a list of the results of applying the function to corresponding pairs of elements from the 
two lists. For example,

	```racket
	(map2 + (1 2 3) (10 11 12))
	```
should evaluate to `(11 13 15)`.
	
	How did you decide to handle the case of lists of different length?<br/> 
	Justify your answer.

2. What does the following expression evaluate to and why?<br/>
What environment is `(f 3)` evaluated in?<br/>
What environment is the body of the lambda evaluated in?
	```racket
   (let ((x 2))
         (let ((f (lambda (n) (+ x n))))
           (let ((x 17))
             (f 3))))
	```
	
3. What does the following expression evaluate to and why?
	```racket
   (define (addN n)
         (lambda (m) (+ m n)))
       (let* ((m 10)
              (n 20)
              (addit (addN 3)))
         (addit 100))
	```

4. What is the result of evaluating the following expression and why?
	```racket
   (let ((f (lambda () (/ 1 0)))
             (x (+ 3 4)))
	 	(+ x x))
	```
	
5. Define a `struct` called `point3d` that represents 3D points. 
Create a point `p` at the origin; change the `z` value to `10` and print it out. 
The result should print as
	```racket
	(point3d 0 0 10)
	```
	
6. Define a `make-cell` function that returns a simulated instance of a cell with a single field `value`, 
which should be hidden (using lexical scoping). 
The cell should provide “methods” for `get-value` and `set-value!`.

	Follow the bank account example when doing this. The `value` should start out as `null`.
	
7. Similarly but with more bells and whistles... define a `make-point` function that returns a 
simulated instance of a point with `x` and `y` fields, which should be hidden (using lexical scoping). 
The point should provide “methods” for `get-x`, `get-y`, `set-x!`, `set-y!`, and `print-point`.

	Again, follow the bank account example when doing this. 
	The various fields should start out with a value of `0`.


