#lang racket

(require "find-blacks.rkt"
         "find-spots.rkt"
         "display-spots.rkt")

(define img "sample1.png")

(let ((argv (current-command-line-arguments)))
  (unless (zero? (vector-length argv))
    (set! img (vector-ref argv 0))))

(display-spots (find-spots (find-blacks img)))
