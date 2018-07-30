#!/usr/local/bin/racket
#lang racket

(provide find-blacks)

(require racket/draw)

(define black?
  (lambda (bm x y)
    (let* ((argb (bytes 0 0 0 0))
           (dummy (send bm get-argb-pixels x y 1 1 argb))
           (r (bytes-ref argb 1))
           (g (bytes-ref argb 2))
           (b (bytes-ref argb 3)))
;;      (display (format "(~a:~a) ~a ~a ~a~%" x y r g b))
      (and (< r 50) (< g 50) (< b 50)))))

(define find-blacks-aux
  (lambda (filename)
    (let ((bm (make-object bitmap% filename)))
      (for/list ([y (range (send bm get-height))])
        (for/list ([x (range (send bm get-width))] #:when (black? bm x y))
          (list x y))))))

(define find-blacks
  (lambda (filename)
    (filter (lambda (x) (not (empty? x))) (find-blacks-aux filename))))

;;(find-blacks "sample1.png")

