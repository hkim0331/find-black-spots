#lang racket

(require racket/draw)

(define crop
  (lambda (infile top left width height outfile)
    (let* ((bm1 (make-object bitmap% infile))
           (pixels (make-bytes (* 4 width height)))
           (bm2 (make-object bitmap% width height #f #t 1.0)))
      (send bm1 get-argb-pixels top left width height pixels)
      (send bm2 set-argb-pixels 0 0 width height pixels)
      (send bm2 save-file outfile 'png))))
