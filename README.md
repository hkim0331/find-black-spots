# find-black-spots
create: 2018-07-28.<br>
update: 2018-07-29, 2018-07-30, 2018-08-01, 2018-08-07.

2018 PBL の裏面回答。

OpenCV等のグラフックライブラリによらずに、
2Dイメージ上の黒スポットを認識する racket プログラム。

三つに分けてプログラムする。

* find-blacks ... 横一列に並んだ黒を見つける。

* find-spots ... 縦横に接触した黒をまとめる。

* display-spots ... 接触した黒ごとに別色で表示する。

# find-black-spots

```
$ ./find-black-spots.rkt img.png
```

イメージファイル img.png を引数にとり、
グループごとに色分けし、spots.png にセーブする。

グループとは「黒で接触しているイメージ」。これをどう Scheme で表現するかが問題。

* 横一列に黒が連続する部分を **セグメント** と定義、

次の二つを満足するとき、「二つのセグメントは接触している」と判定する。

* 二つのセグメントに、共通する x 座標のものがあり、
* それらの y 座標は 1 しか違わないものがある。

# 下請け (1/3) find-blacks.rkt

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

# 下請け (2/3) find-spots.rkt

```lisp
(find-spots lines)
```

find-back-spots で一番がんばる部分。

黒のまとまり（接触がある黒セグメントの集まり）をリストで返す。
y 座標が連続していて、かつ、
セグメント内に同じ x 座標のピクセルがあるセグメント同士をくっつける。

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

# 下請け (3/3) display-spots.rkt

```
(display-spots spots)
```

見つけたスポットごとに色を変えて表示（坂口への宿題だったはず）。

カラーを選択する関数のほか、スポットごとにピクセルを塗りつぶす関数。
find-black-spots 中、一番イージーな部分。

コアな関数だけ示す。詳細はファイルをあたれ。

```lisp
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
```

# find-black-spots.rkt

あとはまとめるだけ。
必要な関数は 3 つのファイルから provide してある。

```
#lang racket
(require "find-blacks.rkt"
         "find-spots.rkt"
         "display-spots.rkt")

(display-spots (find-spots (find-blacks img)))
```

# 実行時間

sample2.png のサイズは 648 x 498。

```
$ time racket find-black-spots.rkt sample2.png
2.49 real         2.35 user         0.13 sys
```

最初のバグったプログラムでは同じことやろうとして 70 秒弱かかった。

バグ修正した上、30倍以上高速になった。理由は余計な場所を探さなくなった
こと。

さらに 2 倍程度の高速化の見込みあり。それはどこでしょう？

（馬場の未完成版プログラムは何秒かかった？
発表では具体的なデータを出すこと。）

# 宿題出てるのに、

* やってこないのは誰だ？

* 手もつけないのは誰だ？

* 完璧でなくてもいい。「時間と能力を尽くしてやってみた」ところを見せなさい。

* 完璧じゃない方がゼミのトピックに好適。

* 手もつけないか、お茶を濁したようなその場しのぎのプログラム持ってきたって
  お勉強にならないよ。

# FIX

* POLISH_UP: 2018-08-07, 3年生の 3 位入賞（準優勝？）を記念して、
  テキストの文言修正。

* BUG: 2018-07-29, 上下に分離できていない。
  FIX: 2018-07-29.

* 算出したスポットを表示する関数 display-spot.
  DONE: 2018-07-29.

---
hiroshi . kimura . 0331 @ gmail . com
