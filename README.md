# find-black-spots
create: 2018-07-28.<br>
update: 2018-07-29,

2018 PBL の裏面回答。
OpenCV等のグラフックライブラリによらずに、
2Dイメージ上の黒スポットを認識する racket プログラム。

## find-black-spots

```
$ ./find-black-spots.rkt img.png
```

イメージファイル img.png を引数にとり、
グループごとに色分けし、spots.png にセーブ。

グループとは「黒で接触しているイメージ」。これをどう Scheme で表現するかが問題。

* 横一列に黒が連続する部分をセグメントと定義する。
* 二つのセグメントに、共通する x 座標のものがあり、
* それらの y 座標は1しか違わないものがあるとき、

接触していると考える。

## find-blacks.rkt

```
(find-blacks "filename.png")
```
イメージファイルを引数にとり、黒と判定されるピクセルの座標を行ごとに返す。

黒を発見しない行は戻り値から外す。

## find-spots.rkt

```
(find-spots lines)
```

黒のまとまりをリストで返す。

## display-spots.rkt

```
(display-spots spots)
```

見つけたスポットごとに色を変えて表示（坂口への宿題だったはず）。

## find-black-spots.rkt

あとはまとめるだけ。

```
#lang racket
(require "find-blacks.rkt" "find-spots.rkt" "display-spots.rkt")
(define spots (find-spots (find-blacks img)))
(display-spots spots)
```

## 実行時間

```
time racket find-black-spots.rkt sample2.png
#t
        2.49 real         2.35 user         0.13 sys
```

## FIXME

* BUG: 2018-07-29, 上下に分離できていない。
  FIX: 2018-07-29.

* 算出したスポットを表示する関数 display-spot. 
  DONE: 2018-07-29.

---
hiroshi.kimura.0331@gmail.com
