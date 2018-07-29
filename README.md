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

グループとは黒で接触しているイメージ。

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


## find-black-spots.rkt

```
#lang racket
(require "find-blacks.rkt" "find-spots.rkt")
(find-spots (find-blacks "sample2.png"))
```

## 実行時間

obsolete. must be rewritten.

* sample2.png --- 30x23
* sample.png ---  648x498

```
> (time (find-spots (find-black "sample2.png")))
cpu time: 5 real time: 4 gc time: 0
> (time (find-spots (find-blacks "sample.png")))
cpu time: 68055 real time: 68231 gc time: 434
```

common-x? を改良したおかげでスピードアップなったはず(2018-07-29).

## FIXME

* BUG: 2018-07-29, 上下に分離できていない。
  => FIX.

* 算出したスポットを表示する関数 display-spot
  => DONE.

---
hiroshi.kimura.0331@gmail.com
