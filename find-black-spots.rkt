#!/usr/local/bin/racket
#lang racket

(require "find-blacks.rkt"
         "find-spots.rkt"
         "display-spots.rkt")

(define img "sample.png")
(let ((argv (current-command-line-arguments)))
  (unless (zero? (vector-length argv))
    (set! img (vector-ref argv 0))))

(define spots (find-spots (find-blacks img)))
(display-spots spots)
