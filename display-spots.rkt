#lang racket
;; 色を変えながらプロット。
;; 2018-07-19 に坂口に出した宿題の回答。
;; https://redmine.melt.kyutech.ac.jp/issues/5107

(provide display-spots)

(require racket/draw)

(define max-f
  (lambda (xys f)
    (apply max (map f xys))))

(define max-x
  (lambda (xys)
    (max-f xys first)))

(define max-y
  (lambda (xys)
    (max-f xys second)))

;; *c* は *colors* のインデックスとする。
(define *colors*
  (list->vector (list (bytes 255 0 0 0)
                      (bytes 255 255 0 0)
                      (bytes 255 0 255 0)
                      (bytes 255 0 0 255)
                      (bytes 255 255 255 0)
                      (bytes 255 255 0 255)
                      (bytes 255 0 255 255))))
(define *c* 0)
(define next-color
  (lambda ()
    (set! *c* (modulo (+ 1 *c*) (vector-length *colors*)))
    (vector-ref *colors* *c*)))

(define display-spot
  (lambda (spot bm)
    (let ((argb (next-color)))
      (for ([xy spot])
        (send bm set-argb-pixels (first xy) (second xy) 1 1 argb)))))

(define display-spots-aux
  (lambda (spots bm)
    (map (lambda (s) (display-spot s bm)) spots)))

;; spots のx、yの最大値でビットマップのサイズを決めたあと、
;; spot  ごとに色を変えて描画し、
;; 出来上がりビットマップを spots.png にセーブする。
(define display-spots
  (lambda (spots)
    (let* ((w (apply max (map max-x spots)))
           (h (apply max (map max-y spots)))
           (bm (make-object bitmap% w h)))
      (display-spots-aux spots bm)
      (send bm save-file "spots.png" 'png))))
