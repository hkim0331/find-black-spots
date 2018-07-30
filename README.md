# find-black-spots
create: 2018-07-28.<br>
update: 2018-07-29, 2018-07-30.

2018 PBL の裏面回答。

OpenCV等のグラフックライブラリによらずに、
2Dイメージ上の黒スポットを認識する racket プログラム。

三つに分けてプログラムする。

* find-blacks
* find-spots
* display-spots

# find-black-spots

```
$ ./find-black-spots.rkt img.png
```

イメージファイル img.png を引数にとり、
グループごとに色分けし、spots.png にセーブする。

グループとは「黒で接触しているイメージ」。これをどう Scheme で表現するかが問題。

* 横一列に黒が連続する部分をセグメントと定義する。
* 二つのセグメントに、共通する x 座標のものがあり、
* それらの y 座標は1しか違わないものがあるとき、

「二つのセグメントは接触している」と判定する。

# find-blacks.rkt

```lisp
(find-blacks "filename.png")
```
イメージファイルを引数にとり、黒と判定されるピクセルの座標を行ごとに返す。

黒が見つからない行は戻り値から外す。


コアな関数だけ示す。詳細は同梱するファイルを。

```lisp
(define find-blacks-aux
  (lambda (filename)
    (let ((bm (make-object bitmap% filename)))
      (for/list ([y (range (send bm get-height))])
        (for/list ([x (range (send bm get-width))] #:when (black? bm x y))
          (list x y))))))
```

# find-spots.rkt

```lisp
(find-spots lines)
```

黒のまとまりをリストで返す。

コアな関数だけ。y-1 は変数だよ。詳しくは同梱するファイルを見ること。

```lisp
;; common-x? は名前が変。
(define common-x?
  (lambda (s1 s2)
    (let* ((x1 (map car s1))
           (y-1 (- (second (first s1)) 1))
           (x2 (map car
                    (filter
                     (lambda (xy) (= y-1 (second xy)))
                     s2))))
      (not (empty? (set-intersect x1 x2))))))
```

# display-spots.rkt

```
(display-spots spots)
```

見つけたスポットごとに色を変えて表示（坂口への宿題だったはず）。
コアな関数だけ示す。他はファイルをあたれ。

```lisp
(define display-spot
  (lambda (spot bm)
    (let ((argb (vector-ref colors *c*)))
      (for ([xy spot])
        (send bm set-argb-pixels (first xy) (second xy) 1 1 argb))
      (set! *c* (modulo (+ *c* 1) (vector-length colors))))))
```

引数に取らない colors も \*c\* と同様、\*colors\* にするべきかも。

# find-black-spots.rkt

あとはまとめるだけ。

```
#lang racket
(require "find-blacks.rkt" "find-spots.rkt" "display-spots.rkt")

(display (find-spots (find-blacks img)))
```

# 実行時間

sample2.png のサイズは 648 x 498。

```
$ time racket find-black-spots.rkt sample2.png
2.49 real         2.35 user         0.13 sys
```

# 宿題出てるのに、

* やってこないのは誰だ？
* 手もつけないのは誰だ？
* 完璧でなくてもいい。「時間と能力を尽くしてやってみた」ところを見せなさい。
* 完璧じゃない方がゼミのトピックに好適。
* 手もつけないか、お茶を濁したようなその場しのぎのプログラム持ってきたって
  お勉強にならないよ。

# FIXME

* BUG: 2018-07-29, 上下に分離できていない。
  FIX: 2018-07-29.

* 算出したスポットを表示する関数 display-spot.
  DONE: 2018-07-29.

---
hiroshi.kimura.0331@gmail.com
