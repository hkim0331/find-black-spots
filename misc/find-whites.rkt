#lang racket
(require "find-color.rkt")

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

(define red?
  (lambda (bm x y)
    (let ((argb (bytes 0 0 0 0)))
      (send bm get-argb-pixels x y 1 1 argb)
      (and (< 200(bytes-ref argb 1))
           (< (bytes-ref argb 2) 50)
           (< (bytes-ref argb 50))))))
;; test run
;; not empty to remove empty lines.
(define find-blacks
  (lambda (filename)
    (filter (lambda (x) (not (empty? x))) (find-color black? filename))))

(define find-whites
  (lambda (filename)
    (filter (lambda (x) (not (empty? x))) (find-color white? filename))))

