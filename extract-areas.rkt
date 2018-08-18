#lang racket

(require racket/draw
         "find-color.rkt"
         "find-spots.rkt"
         "display-spots.rkt")

(define white?
  (lambda (bm x y)
    (let ((argb (bytes 0 0 0 0)))
      (send bm get-argb-pixels x y 1 1 argb)
      (and (< 200 (bytes-ref argb 1))
           (< 200 (bytes-ref argb 2))
           (< 200 (bytes-ref argb 3))))))

; (define average
;   (lambda (xs)
;     (round (/ (apply + xs) (length xs)))))

; (define cg
;   (lambda (xys)
;     (map average (apply map list xys))))

(define left-top-right-bottom
  (lambda (xys)
    (let* ((z (apply map list xys))
           (xs (first z))
           (ys (second z)))
      (values
        (apply min xs)
        (apply min ys)
        (apply max xs)
        (apply max ys)))))


(define img "sample6.png")
(let ((argv (current-command-line-arguments)))
  (unless (zero? (vector-length argv))
    (set! img (vector-ref argv 0))))


(define spots (find-spots (find-color white? img)))

(define frame 
  (first 
    (sort spots (lambda (x y) (> (length x) (length y))))))
(define-values (l t r b) (left-top-right-bottom frame))

;(display-spots (list frame))
;(system "open spots.png")

;; what is the frame?
;(define-values (l t r b) (left-top-right-bottom frame))

(define crop
  (lambda (infile top left width height outfile)
    (let* ((bm1 (make-object bitmap% infile))
           (pixels (make-bytes (* 4 width height)))
           (bm2 (make-object bitmap% width height #f #t 1.0)))
      (send bm1 get-argb-pixels top left width height pixels)
      (send bm2 set-argb-pixels 0 0 width height pixels)
      (send bm2 save-file outfile 'png))))

      
(crop "sample6.png" 70 130 70 120 "crop1.png")
(system "open crop1.png")
(crop "sample6.png" 140 130 70 120 "crop2.png")
(system "open crop2.png")
(crop "sample6.png" 210 130 70 120 "crop3.png")
(system "open crop3.png")

