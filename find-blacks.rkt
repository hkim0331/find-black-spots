#!/usr/local/bin/racket
#lang racket
;
; if provide color? predicate,
; can find any color pixels.
;
; usage:
; (find-blacks "sample1.png")
; (find-whites "sample5.png")
;
(provide find-blacks find-whites)

(require racket/draw)

(define black?
  (lambda (bm x y)
    (let ((argb (bytes 0 0 0 0)))
      (send bm get-argb-pixels x y 1 1 argb)
      (and (< (bytes-ref argb 1) 50)
           (< (bytes-ref argb 2) 50)
           (< (bytes-ref argb 3) 50)))))

(define white?
  (lambda (bm x y)
    (let ((argb (bytes 0 0 0 0)))
      (send bm get-argb-pixels x y 1 1 argb)
      (and (< 200 (bytes-ref argb 1))
           (< 200 (bytes-ref argb 2))
           (< 200 (bytes-ref argb 3))))))

(define find-color
  (lambda (color? filename)
    (let ((bm (make-object bitmap% filename)))
      (for/list ([y (range (send bm get-height))])
        (for/list ([x (range (send bm get-width))] #:when (color? bm x y))
          (list x y))))))

;; 泥縄
(define find-blacks
  (lambda (filename)
    (filter (lambda (x) (not (empty? x))) (find-color black? filename))))

(define find-whites
  (lambda (filename)
    (filter (lambda (x) (not (empty? x))) (find-color white? filename))))

