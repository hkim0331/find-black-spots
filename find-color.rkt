#lang racket
;
; if provide color? predicate,
; can find any color pixels.
;
; usage:
; (find-color black? "sample1.png")
; (find-color white? "sample5.png")
;
(provide find-color)

(require racket/draw)

(define strip
  (lambda (lines)
    (filter (lambda (line) (not (empty? line))) lines)))

(define find-color
  (lambda (color? filename)
    (let ((bm (make-object bitmap% filename)))
      (strip
       (for/list ([y (range (send bm get-height))])
         (for/list ([x (range (send bm get-width))] #:when (color? bm x y))
           (list x y)))))))
