#lang racket

(define (square x) (* x x))

(define (fib n)
	(fib-iter 1 0 0 1 n))

(define (fib-iter a b p q count)
	(cond ((= count 0) b)
				((even? count)
				 (fib-iter a b (+ (square p) (square q)) (+ (* 2 p q) (square q)) (/ count 2)))
				(else (fib-iter (+ (* b q) (* a q) (* a p))
												(+ (* b p) (* a q))
												p
												q
												(- count 1)))))

#;(define (sum-odd-squares tree)
	(cond ((null? tree) 0)
				((not (pair? tree))
				 (if (odd? tree) (square tree) 0))
				(else (+ (sum-odd-squares (car tree))
								 (sum-odd-squares (cdr tree))))))

(define (even-fibs n)
	(define (next k)
		(if (> k n)
			null
			(let ((f (fib k)))
				(if (even? f)
					(cons f (next (+ k 1)))
					(next (+ k 1))))))
	(next 0))

(define (filter predicate sequence)
	(cond ((null? sequence) null)
				((predicate (car sequence))
				 (cons (car sequence)
							 (filter predicate (cdr sequence))))
				(else (filter predicate (cdr sequence)))))

(define (enumerate-interval low high)
	(if (> low high)
		null
		(cons low (enumerate-interval (+ low 1) high))))

(define (enumerate-tree tree)
	(cond ((null? tree) null)
				((not (pair? tree)) (list tree))
				(else (append (enumerate-tree (car tree))
											(enumerate-tree (cdr tree))))))

(define (sum-odd-sequence tree)
	(accumulate + 0 (map square (filter odd? (enumerate-tree tree)))))

(define (accumulate-n op init seqs)
	(if (null? (car seqs))
		null
		(cons (accumulate op init (map car seqs))
					(accumulate-n op init (map cdr seqs)))))

#;(define (transpose seqs)
	(if (null? (car seqs))
		null
		(cons (map car seqs)
					(transpose (map cdr seqs)))))

(define (accumulate-m op init seqs)
	(if (null? (car seqs))
		null
		(map (lambda (seq) (accumulate op init seq)) (transpose seqs))))

(define (dot-product v w)
	(accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
	(map (lambda (row) (dot-product row v)) m))

(define (transpose mat)
	(accumulate-n cons null mat))

(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
				(accumulate op initial (cdr sequence)))))

(define (fold-left op initial sequence)
	(define (iter result rest)
		(if (null? rest)
			result
			(iter (op result (car rest))
						(cdr rest))))
	(iter initial sequence))

(define (fold-right op initial sequence)
	(define (iter result rest)
		(if (null? rest)
			result
			(iter (op (car rest) result)
						(cdr rest))))
	(iter initial sequence))

;;;;;;;;;;;;;;;;;;;;;;;;
(define (l-reverse sequence)
	(fold-left (lambda (x y) (cons y x)) null sequence))

(define (r-reverse sequence)
	(fold-right (lambda (x y) (append (list x) y)) null sequence))
;;;;;;;;;;;;;;;;;;;;;;;;

(define test (list 1 2 3))
(l-reverse test)
(r-reverse test)










