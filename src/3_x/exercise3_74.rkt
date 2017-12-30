#lang racket
(require racket/stream)

; li: list[A]
; return: Stream[A]
(define (list->stream li)
  (define (iter li s)
    (if (null? li)
      s
      (iter (cdr li) (stream-cons (car li) s))))
  (iter (reverse li) empty-stream))

; stream: Stream[number]
; factor: number
; return: Stream[number]
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
              stream))

; s1: Stream[number]
; s2: Stream[number]
; return: Stream[number]
(define (add-stream s1 s2) (stream-map + s1 s2))

; initial-value + Σ(integrand * dt)
; integrand: Stream[number]
; initial-value: number
; dt: number
; return: Stream[number]
(define (integral integrand initial-value dt)
  (define int
    (stream-cons initial-value
                 (add-stream (scale-stream integrand dt)
                 int)))
  int)

; first: number
; second: number
; return: number{-1, 0, 1}
; sicpに書いてあるやつ逆になってる...?
(define (sign-change-detector first second)
  (cond ((and (>= first 0) (< second 0)) 1)
        ((and (< first 0) (>= second 0)) -1)
        (else 0)))

; input-stream: Stream[number]
; last-value: number
; return: Stream[number]
(define (make-zero-crossings input-stream last-value)
  (stream-cons
    (sign-change-detector
      (stream-first input-stream)
      last-value)
    (make-zero-crossings
      (stream-rest input-stream)
      (stream-first input-stream))))

; return: Stream[number]
(define sense-data
  (list->stream (list 1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4)))

; return: Stream[number]
(define zero-crossings
  (make-zero-crossings sense-data 0))

(stream->list sense-data)
(stream-ref zero-crossings 0)
(stream-ref zero-crossings 5)
(stream-ref zero-crossings 9)
(stream-ref zero-crossings 10)

