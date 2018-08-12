#lang racket

(require "find-color.rkt"
         "find-spots.rkt"
         "display-spots.rkt")

(define white?
  (lambda (bm x y)
    (let ((argb (bytes 0 0 0 0)))
      (send bm get-argb-pixels x y 1 1 argb)
      (and (< 200 (bytes-ref argb 1))
           (< 200 (bytes-ref argb 2))
           (< 200 (bytes-ref argb 3))))))

(define img "sample5.jpg")
(let ((argv (current-command-line-arguments)))
  (unless (zero? (vector-length argv))
    (set! img (vector-ref argv 0))))

;(find-color white? img)
(display-spots (find-spots (find-color white? img)))
(system "open spots.png")

