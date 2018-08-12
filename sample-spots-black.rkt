#lang racket

(require "find-color.rkt"
         "find-spots.rkt"
         "display-spots.rkt")

(define img "sample1.png")
(let ((argv (current-command-line-arguments)))
  (unless (zero? (vector-length argv))
    (set! img (vector-ref argv 0))))

(define black?
  (lambda (bm x y)
    (let ((argb (bytes 0 0 0 0)))
      (send bm get-argb-pixels x y 1 1 argb)
      (and (< (bytes-ref argb 1) 50)
           (< (bytes-ref argb 2) 50)
           (< (bytes-ref argb 3) 50)))))

(display-spots (find-spots (find-color black? img)))
(system "open spots.png")
