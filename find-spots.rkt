#!/usr/local/bin/racket
#lang racket

(provide find-spots)

;; generalized pack
(define pack-aux
  (lambda (f? xs tmp ret)
    (cond
      ((null? xs) (cons tmp ret))
      ((null? tmp) (pack-aux f? (cdr xs) (list (car xs)) ret))
      ((f? (car tmp) (car xs)) (pack-aux f? (cdr xs) (cons (car xs) tmp) ret))
      (else
       (pack-aux f? (cdr xs) (list (car xs)) (cons tmp ret))))))

(define pack-f
  (lambda (f? xs)
    (pack-aux f? xs '() '())))

(define cont?
  (lambda (a b)
    (= (+ 1 (car a)) (car b))))

;; pack-f の戻り値を反転して戻り値とする。
(define segmentize
  (lambda (xs)
    (reverse (map reverse (pack-f cont? xs)))))
;; 反転する必要は本来ない。
;; (define segmentize
;;   (lambda (xs)
;;     (pack-f cont? xs)))

;; サンプルデータ
(define make-sample
  (lambda (rng y r)
    (filter (lambda (x) (< (random 10) (* 10 r)))
            (map (lambda (x) (list x y)) (apply range rng)))))

(define line1 (make-sample '(0 20) 1 0.7))
(define line2 (make-sample '(0 20) 2 0.7))
(define line3 (make-sample '(0 20) 3 0.7))

(define seg1 (segmentize line1))
(define seg2 (segmentize line2))
(define seg3 (segmentize line3))

;; 共通の x 座標を持つものがあるか？
;; BUG, y 座標が 1 だけ増えてるやつと比較しないとだめじゃね？
;; FIX.
(define common-x?
  (lambda (s1 s2)
    (let* ((x1 (map car s1))
           (y-1 (- (second (first s1)) 1))
           (x2 (map car
                    (filter
                     (lambda (xy) (= y-1 (second xy)))
                     s2))))
;;      (display (format "~a:~a~%" x1 x2))
      (not (empty? (set-intersect x1 x2))))))

;; mix-in version 2.
;; FIXME: connects と disjoints
(define mix-in
  (lambda (s l)
    (let ((connects
           (filter (lambda (x) (common-x? s x)) l))
          (disjoints
           (filter (lambda (x) (not (common-x? s x))) l)))
      ;; (display (format "s: ~a~%" s))
      ;; (display (format "c: ~a~%" (apply append connects)))
      ;; (display (format "d: ~a~%" disjoints))
      (cons (append s (apply append connects)) disjoints))))

(define join2
  (lambda (l1 l2)
    (if (null? l1)
        l2
        (join2 (cdr l1) (mix-in (car l1) l2)))))

(define find-spots
  (lambda (blacks)
    (let ((lines (map segmentize blacks)))
      (foldl join2 (car lines) (cdr lines)))))

;;BUG FIX.
;; (find-spots '(((0 0) (1 0) (2 0))
;;               ((2 1) (3 1) (4 1))
;;               ((0 2) (1 2) (2 2))))