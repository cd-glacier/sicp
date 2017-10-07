#lang racket

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right) (list entry left right))

(define (element-of-set? x set)
	(cond ((null? set) #f)
				((= x (entry set)) #t)
				((< x (entry set)) (element-of-set? x (left-branch set)))
				((> x (entry set)) (element-of-set? x (right-branch set)))))

(define (adjoin-set x set)
	(cond ((null? set) (make-tree x '() '()))
				((= x (entry set)) set)
				((< x (entry set)) 
				 (make-tree (entry set)
										(adjoin-set x (left-branch set))
										(right-branch set)))
				((> x (entry set))
				 (make-tree (entry set)
										(left-branch set)
										(adjoin-set x (right-branch set))))))

(define (list->tree elements)
	(car (partical-tree elements (length elements))))
(define (partical-tree elts n)
	(if (= n 0)
		(cons '() elts)
		(let ((left-size (quotient (- n 1) 2)))
			(let ((left-result (partical-tree elts left-size)))
				(let ((left-tree (car left-result))
							(non-left-elts (cdr left-result))
							(right-size (- n (+ left-size 1))))
					(let ((this-entry (car non-left-elts))
								(right-result (partical-tree (cdr non-left-elts) right-size)))
						(let ((right-tree (car right-result))
									(remaining-elts
										(cdr right-result)))
							(cons (make-tree this-entry
															 left-tree
															 right-tree)
										remaining-elts))))))))

(define tree1 
	(make-tree 10
						 (make-tree 5
												'()
												'())
						 (make-tree 15
												(make-tree 11
																	 '()
																	 '())
												(make-tree 19
																	 '()
																	 '()))))

(list->tree (list 1 3 5 7 9 11))