(module(memory (import "imports" "memory") 1)

(func $console_log (import "imports" "console_log") (param $ptr i32))
(func $console_warn (import "imports" "console_warn") (param $ptr i32))
(func $console_error (import "imports" "console_error") (param $ptr i32))
(func $rand (import "imports" "rand") (result f32))
(func $cos (import "imports" "cos") (param $a f32) (result f32))
(func $log (import "imports" "log") (param $a f32) (result f32))
(func $^ (import "imports" "^") (param $a f32) (param $b f32) (result f32))
(func $println (import "imports" "println") (param $a i32))
(func $error (import "imports" "error") (param $a i32))

(func $_ternary (export "_ternary") (param $x i32) (param $y i32) (result i32)
(block ( br_if 0 ( i32.eqz ( i32.lt_s (local.get $x) (local.get $y) ) ) )
( return (i32.const 0) )
) ( return (i32.const 1) ))

(func $_nestedloop1 (export "_nestedloop1") (result f32) 
 (local $_2 i32) (local $s f32) (local $_4 i32) (local $i i32) (local $j i32) (local $_2i i32) (local $_4i i32)
( local.set $s (f32.const 0.0) )
( local.set $_2 ( local.set $_2i ( call $iterateunitrange_init (i32.const 1) (i32.const 9) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (i32.const 1) ) ) ) )
(loop
( local.set $i (local.get $_2) )
(local.get $_2i)
( local.set $s  ( f32.add (local.get $s) (f32.const 2.1) )  )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange_init (i32.const 1) (i32.const 3) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (i32.const 1) ) ) ) )
(loop
( local.set $j (local.get $_4) )
(local.get $_4i)
( local.set $s  ( f32.add (local.get $s) (f32.const 7.1) )  )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange (i32.const 1) (i32.const 3) (local.get $_4) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_4i) ) ) ) )
(br 0)
) ) ( local.set $_2 ( local.set $_2i ( call $iterateunitrange (i32.const 1) (i32.const 9) (local.get $_2) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_2i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

(func $_println (export "_println") (param $n i32) (result i32)
(block (block ( br_if 0 ( i32.eqz ( i32.lt_s (local.get $n) (i32.const 3) ) ) )
(call $setsize_tmp (i32.const 43) (i32.const 1))
(call $setlinearindex_int_tmp (i32.const 84) (i32.const 1)) ;;T
(call $setlinearindex_int_tmp (i32.const 104) (i32.const 2)) ;;h
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 3)) ;;i
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 4)) ;;s
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 5)) ;; 
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 6)) ;;i
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 7)) ;;s
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 8)) ;; 
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 9)) ;;a
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 10)) ;; 
(call $setlinearindex_int_tmp (i32.const 109) (i32.const 11)) ;;m
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 12)) ;;e
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 13)) ;;s
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 14)) ;;s
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 15)) ;;a
(call $setlinearindex_int_tmp (i32.const 103) (i32.const 16)) ;;g
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 17)) ;;e
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 18)) ;; 
(call $setlinearindex_int_tmp (i32.const 118) (i32.const 19)) ;;v
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 20)) ;;i
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 21)) ;;s
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 22)) ;;i
(call $setlinearindex_int_tmp (i32.const 98) (i32.const 23)) ;;b
(call $setlinearindex_int_tmp (i32.const 108) (i32.const 24)) ;;l
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 25)) ;;e
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 26)) ;; 
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 27)) ;;a
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 28)) ;;s
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 29)) ;; 
(call $setlinearindex_int_tmp (i32.const 99) (i32.const 30)) ;;c
(call $setlinearindex_int_tmp (i32.const 111) (i32.const 31)) ;;o
(call $setlinearindex_int_tmp (i32.const 110) (i32.const 32)) ;;n
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 33)) ;;s
(call $setlinearindex_int_tmp (i32.const 111) (i32.const 34)) ;;o
(call $setlinearindex_int_tmp (i32.const 108) (i32.const 35)) ;;l
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 36)) ;;e
(call $setlinearindex_int_tmp (i32.const 46) (i32.const 37)) ;;.
(call $setlinearindex_int_tmp (i32.const 108) (i32.const 38)) ;;l
(call $setlinearindex_int_tmp (i32.const 111) (i32.const 39)) ;;o
(call $setlinearindex_int_tmp (i32.const 103) (i32.const 40)) ;;g
(call $setlinearindex_int_tmp (i32.const 40) (i32.const 41)) ;;(
(call $setlinearindex_int_tmp (i32.const 41) (i32.const 42)) ;;)
(call $setlinearindex_int_tmp (i32.const 46) (i32.const 43)) ;;.
(call $console_log (i32.const 4))
(br 1)
) ( return (i32.const 1) )
) ( return (i32.const 2) ))

(func $_error (export "_error") (param $n i32) (result i32)
(block (block ( br_if 0 ( i32.eqz ( i32.lt_s (local.get $n) (i32.const 3) ) ) )
(call $setsize_tmp (i32.const 96) (i32.const 1))
(call $setlinearindex_int_tmp (i32.const 84) (i32.const 1)) ;;T
(call $setlinearindex_int_tmp (i32.const 104) (i32.const 2)) ;;h
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 3)) ;;i
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 4)) ;;s
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 5)) ;; 
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 6)) ;;i
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 7)) ;;s
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 8)) ;; 
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 9)) ;;a
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 10)) ;; 
(call $setlinearindex_int_tmp (i32.const 109) (i32.const 11)) ;;m
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 12)) ;;e
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 13)) ;;s
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 14)) ;;s
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 15)) ;;a
(call $setlinearindex_int_tmp (i32.const 103) (i32.const 16)) ;;g
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 17)) ;;e
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 18)) ;; 
(call $setlinearindex_int_tmp (i32.const 118) (i32.const 19)) ;;v
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 20)) ;;i
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 21)) ;;s
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 22)) ;;i
(call $setlinearindex_int_tmp (i32.const 98) (i32.const 23)) ;;b
(call $setlinearindex_int_tmp (i32.const 108) (i32.const 24)) ;;l
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 25)) ;;e
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 26)) ;; 
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 27)) ;;a
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 28)) ;;s
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 29)) ;; 
(call $setlinearindex_int_tmp (i32.const 99) (i32.const 30)) ;;c
(call $setlinearindex_int_tmp (i32.const 111) (i32.const 31)) ;;o
(call $setlinearindex_int_tmp (i32.const 110) (i32.const 32)) ;;n
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 33)) ;;s
(call $setlinearindex_int_tmp (i32.const 111) (i32.const 34)) ;;o
(call $setlinearindex_int_tmp (i32.const 108) (i32.const 35)) ;;l
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 36)) ;;e
(call $setlinearindex_int_tmp (i32.const 46) (i32.const 37)) ;;.
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 38)) ;;e
(call $setlinearindex_int_tmp (i32.const 114) (i32.const 39)) ;;r
(call $setlinearindex_int_tmp (i32.const 114) (i32.const 40)) ;;r
(call $setlinearindex_int_tmp (i32.const 111) (i32.const 41)) ;;o
(call $setlinearindex_int_tmp (i32.const 114) (i32.const 42)) ;;r
(call $setlinearindex_int_tmp (i32.const 40) (i32.const 43)) ;;(
(call $setlinearindex_int_tmp (i32.const 41) (i32.const 44)) ;;)
(call $setlinearindex_int_tmp (i32.const 44) (i32.const 45)) ;;,
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 46)) ;; 
(call $setlinearindex_int_tmp (i32.const 102) (i32.const 47)) ;;f
(call $setlinearindex_int_tmp (i32.const 111) (i32.const 48)) ;;o
(call $setlinearindex_int_tmp (i32.const 108) (i32.const 49)) ;;l
(call $setlinearindex_int_tmp (i32.const 108) (i32.const 50)) ;;l
(call $setlinearindex_int_tmp (i32.const 111) (i32.const 51)) ;;o
(call $setlinearindex_int_tmp (i32.const 119) (i32.const 52)) ;;w
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 53)) ;;e
(call $setlinearindex_int_tmp (i32.const 100) (i32.const 54)) ;;d
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 55)) ;; 
(call $setlinearindex_int_tmp (i32.const 98) (i32.const 56)) ;;b
(call $setlinearindex_int_tmp (i32.const 121) (i32.const 57)) ;;y
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 58)) ;; 
(call $setlinearindex_int_tmp (i32.const 117) (i32.const 59)) ;;u
(call $setlinearindex_int_tmp (i32.const 110) (i32.const 60)) ;;n
(call $setlinearindex_int_tmp (i32.const 99) (i32.const 61)) ;;c
(call $setlinearindex_int_tmp (i32.const 114) (i32.const 62)) ;;r
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 63)) ;;e
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 64)) ;;a
(call $setlinearindex_int_tmp (i32.const 99) (i32.const 65)) ;;c
(call $setlinearindex_int_tmp (i32.const 104) (i32.const 66)) ;;h
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 67)) ;;a
(call $setlinearindex_int_tmp (i32.const 98) (i32.const 68)) ;;b
(call $setlinearindex_int_tmp (i32.const 108) (i32.const 69)) ;;l
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 70)) ;;e
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 71)) ;; 
(call $setlinearindex_int_tmp (i32.const 40) (i32.const 72)) ;;(
(call $setlinearindex_int_tmp (i32.const 116) (i32.const 73)) ;;t
(call $setlinearindex_int_tmp (i32.const 114) (i32.const 74)) ;;r
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 75)) ;;a
(call $setlinearindex_int_tmp (i32.const 112) (i32.const 76)) ;;p
(call $setlinearindex_int_tmp (i32.const 41) (i32.const 77)) ;;)
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 78)) ;; 
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 79)) ;;i
(call $setlinearindex_int_tmp (i32.const 110) (i32.const 80)) ;;n
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 81)) ;; 
(call $setlinearindex_int_tmp (i32.const 119) (i32.const 82)) ;;w
(call $setlinearindex_int_tmp (i32.const 97) (i32.const 83)) ;;a
(call $setlinearindex_int_tmp (i32.const 115) (i32.const 84)) ;;s
(call $setlinearindex_int_tmp (i32.const 109) (i32.const 85)) ;;m
(call $setlinearindex_int_tmp (i32.const 32) (i32.const 86)) ;; 
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 87)) ;;e
(call $setlinearindex_int_tmp (i32.const 120) (i32.const 88)) ;;x
(call $setlinearindex_int_tmp (i32.const 101) (i32.const 89)) ;;e
(call $setlinearindex_int_tmp (i32.const 99) (i32.const 90)) ;;c
(call $setlinearindex_int_tmp (i32.const 117) (i32.const 91)) ;;u
(call $setlinearindex_int_tmp (i32.const 116) (i32.const 92)) ;;t
(call $setlinearindex_int_tmp (i32.const 105) (i32.const 93)) ;;i
(call $setlinearindex_int_tmp (i32.const 111) (i32.const 94)) ;;o
(call $setlinearindex_int_tmp (i32.const 110) (i32.const 95)) ;;n
(call $setlinearindex_int_tmp (i32.const 46) (i32.const 96)) ;;.
(call $console_error (i32.const 4))
(unreachable)
(br 1)
) ( return (i32.const 1) )
) ( return (i32.const 2) ))

(func $_ifelse (export "_ifelse") (param $n i32) (result i32)
( return ( select (local.get $n) (i32.const 7) ( i32.gt_s (local.get $n) (i32.const 3) ) ) ))

(func $_multiternary (export "_multiternary") (param $x i32) (param $y i32) (result i32)
(block ( br_if 0 ( i32.eqz ( i32.lt_s (local.get $x) (local.get $y) ) ) )
( return (i32.const 1) )
)
(block ( br_if 0 ( i32.eqz ( i32.gt_s (local.get $x) (local.get $y) ) ) )
( return (i32.const -1) )
) ( return (i32.const 0) ))

(func $_continue1 (export "_continue1") (result f32) 
 (local $_2 i32) (local $s f32) (local $i i32) (local $_2i i32)
( local.set $s (f32.const 0.0) )
( local.set $_2 ( local.set $_2i ( call $iterateunitrange_init (i32.const 1) (i32.const 9) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (i32.const 1) ) ) ) )
(loop
( local.set $i (local.get $_2) )
(local.get $_2i)
(block (block ( br_if 0 ( i32.eqz ( i32.eq (local.get $i) (i32.const 3) ) ) )
(br 1)
) ( local.set $s  ( f32.add (local.get $s) (f32.const 2.1) )  )
) ( local.set $_2 ( local.set $_2i ( call $iterateunitrange (i32.const 1) (i32.const 9) (local.get $_2) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_2i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

(func $_break1 (export "_break1") (result f32) 
 (local $_2 i32) (local $s f32) (local $i i32) (local $_2i i32)
( local.set $s (f32.const 0.0) )
( local.set $_2 ( local.set $_2i ( call $iterateunitrange_init (i32.const 1) (i32.const 9) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (i32.const 1) ) ) ) )
(loop
( local.set $i (local.get $_2) )
(local.get $_2i)
(block ( br_if 0 ( i32.eqz ( i32.eq (local.get $i) (i32.const 3) ) ) )
(br 2)
) ( local.set $s  ( f32.add (local.get $s) (f32.const 2.1) )  )
( local.set $_2 ( local.set $_2i ( call $iterateunitrange (i32.const 1) (i32.const 9) (local.get $_2) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_2i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

(func $_ifblock_withreturn (export "_ifblock_withreturn") (param $x i32) (param $y i32) (result i32)
(block ( br_if 0 ( i32.eqz ( i32.lt_s (local.get $x) (local.get $y) ) ) )
( return (i32.const 0) )
) ( return (i32.const 1) ))

(func $_nestedloopwithinnerbreak1 (export "_nestedloopwithinnerbreak1") (result f32) 
 (local $_2 i32) (local $s f32) (local $_4 i32) (local $i i32) (local $j i32) (local $_2i i32) (local $_4i i32)
( local.set $s (f32.const 0.0) )
( local.set $_2 ( local.set $_2i ( call $iterateunitrange_init (i32.const 1) (i32.const 9) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (i32.const 1) ) ) ) )
(loop
( local.set $i (local.get $_2) )
(local.get $_2i)
( local.set $s  ( f32.add (local.get $s) (f32.const 2.1) )  )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange_init (i32.const 1) (i32.const 3) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (i32.const 1) ) ) ) )
(loop
( local.set $j (local.get $_4) )
(local.get $_4i)
(block ( br_if 0 ( i32.eqz ( i32.eq (local.get $j) (i32.const 2) ) ) )
(br 2)
) ( local.set $s  ( f32.add (local.get $s) (f32.const 7.1) )  )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange (i32.const 1) (i32.const 3) (local.get $_4) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_4i) ) ) ) )
(br 0)
) ) ( local.set $_2 ( local.set $_2i ( call $iterateunitrange (i32.const 1) (i32.const 9) (local.get $_2) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_2i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

(func $_logicalAND (export "_logicalAND") (param $k i32) (result i32)
(block ( br_if 0 ( i32.eqz ( i32.eq (local.get $k) (i32.const 3) ) ) )
( return (i32.const 9) )
) ( return (local.get $k) ))

(func $_nestedloopwithinnercontinue1 (export "_nestedloopwithinnercontinue1") (result f32) 
 (local $_2 i32) (local $s f32) (local $_4 i32) (local $i i32) (local $j i32) (local $_2i i32) (local $_4i i32)
( local.set $s (f32.const 0.0) )
( local.set $_2 ( local.set $_2i ( call $iterateunitrange_init (i32.const 1) (i32.const 9) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (i32.const 1) ) ) ) )
(loop
( local.set $i (local.get $_2) )
(local.get $_2i)
( local.set $s  ( f32.add (local.get $s) (f32.const 2.1) )  )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange_init (i32.const 1) (i32.const 3) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (i32.const 1) ) ) ) )
(loop
( local.set $j (local.get $_4) )
(local.get $_4i)
(block (block ( br_if 0 ( i32.eqz ( i32.eq (local.get $j) (i32.const 2) ) ) )
(br 1)
) ( local.set $s  ( f32.add (local.get $s) (f32.const 7.1) )  )
) ( local.set $_4 ( local.set $_4i ( call $iterateunitrange (i32.const 1) (i32.const 3) (local.get $_4) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_4i) ) ) ) )
(br 0)
) ) ( local.set $_2 ( local.set $_2i ( call $iterateunitrange (i32.const 1) (i32.const 9) (local.get $_2) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_2i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

(func $_if1 (export "_if1") (param $n i32) (result i32)
(block ( br_if 0 ( i32.eqz ( i32.gt_s (local.get $n) (i32.const 3) ) ) )
( return (local.get $n) )
) ( return (i32.const 7) ))

(func $_if_elseif_else (export "_if_elseif_else") (param $x i32) (param $y i32) (result i32)
(block ( br_if 0 ( i32.eqz ( i32.lt_s (local.get $x) (local.get $y) ) ) )
( return (i32.const 1) )
)
(block ( br_if 0 ( i32.eqz ( i32.gt_s (local.get $x) (local.get $y) ) ) )
( return (i32.const -1) )
) ( return (i32.const 0) ))

(func $_logicalOR (export "_logicalOR") (param $k i32) (result i32)
(block (block ( br_if 0 ( i32.eqz ( i32.eq (local.get $k) (i32.const 3) ) ) )
(br 1)
) ( return (i32.const 9) )
) ( return (local.get $k) ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; handwritten webassembly builtins below here (unused will be discarded)    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                       Implementation notes for dev                        ;;
;; Define/Assume some datastructure:                                         ;;
;; arrays are always 2d                                                      ;;
;; array size are i32 and occupy first 2 elements                            ;;
;; array elements are f32                                                    ;;
;; array references are bytepointers (bytepointer = 4*index)                 ;;
;;                                                                           ;;
;; so in summary:                                                            ;;
;; size(M,1) = memory[M]                                                     ;;
;; size(M,2) = memory[M+4]                                                   ;;
;; M[1] = memory[M + 4 + 4]                                                  ;;
;; M[i] = memory[M + 4 + 4*i] =  memory[M + 4*(1+i)]                         ;;
;; Ḿ[i,j] = memory[M + 4 + 4*(i + (j-1)*size(M,1))]                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;allocate some initial memory for counting used memory and holding temporary arrays
;;memory[0] is supposed to always point to the first currently un-allocated memory
;;so initial memory[0] = 
(func $allocate_init (export "allocate_init")
  (local $tmplen i32)
  (local.set $tmplen (i32.const 282)) ;;max length of any temporary array (mostly used for console.log("my string") without allocation). Lets do 280 like twitter because why not
  (i32.store (i32.const 0) (call $mul4 (i32.add (i32.const 1) (local.get $tmplen) )))
)

(func $mul4 (param $i i32) (result i32)
  (i32.shl (local.get $i) (i32.const 2))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; size / length
(func $size1 (param $M i32) (result i32)
  (i32.load (local.get $M))
)

(func $size2 (param $M i32) (result i32)
  (i32.load (i32.add (local.get $M) (i32.const 4)))
)

(func $size (export "size") (param $M i32) (result i32 i32)
  (call $size1 (local.get $M))
  (call $size2 (local.get $M))
)

(func $length (export "length") (param $M i32) (result i32)
  (i32.mul (call $size (local.get $M)))
)

(func $setsize (export "setsize") (param $M i32) (param $i i32) (param $j i32)
  (i32.store (local.get $M) (local.get $i))
  (i32.store (i32.add (local.get $M) (i32.const 4)) (local.get $j))
)

;;add 8+4*len to mem[0], return what mem[0] was before
(func $allocate (export "allocate") (param $a i32) (param $b i32) (result i32)
  (local $ptr i32)
  (local.set $ptr (i32.load (i32.const 0)))
  (i32.store (i32.const 0)
    (i32.add (i32.const 8) (i32.add (local.get $ptr)) (call $mul4 (i32.mul (local.get $a) (local.get $b))))
  )
  (local.get $ptr)
)

(func $copy (export "copy") (param $M i32) (result i32)
  (local $C i32) (local $i i32) (local $N i32) (local $a i32) (local $b i32)
  (local.set $a (call $size1 (local.get $M)))
  (local.set $b (call $size2 (local.get $M)))
  (local.set $C (call $allocate (local.get $a) (local.get $b)))
  (call $setsize (local.get $C) (local.get $a) (local.get $b))

  (local.set $i (i32.const 1))
  (local.set $N (i32.mul (local.get $a) (local.get $b)))
  (loop 
    (call $setlinearindex (local.get $C) (call $getlinearindex (local.get $M) (local.get $i)) (local.get $i))
    (br_if 0 (i32.le_s (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $N)))
  )
  (local.get $C)
)

(func $requiredpages (export "requiredpages") (result i32)
  (i32.add (i32.div_s (i32.load (i32.const 0)) (i32.const 64000)) (i32.const 1))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; linear getindex / setindex

(func $bytepointer (param $M i32) (param $i i32) (result i32)
  (i32.add (local.get $M) (call $mul4 (i32.add (local.get $i) (i32.const 1))))
)

(func $getlinearindex (param $M i32) (param $i i32) (result f32)
  (f32.load (call $bytepointer (local.get $M) (local.get $i)))
)

(func $setlinearindex (export "setlinearindex") (param $M i32) (param $x f32) (param $i i32)
  (f32.store (call $bytepointer (local.get $M) (local.get $i)) (local.get $x))
)

(func $setlinearindex_int (export "setlinearindex_int") (param $M i32) (param $x i32) (param $i i32)
  (i32.store (call $bytepointer (local.get $M) (local.get $i)) (local.get $x))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; matrix getindex / setindex

(func $linearindex (param $M i32) (param $i i32) (param $j i32) (result i32)
  (i32.add (local.get $i) (i32.mul (i32.sub (local.get $j) (i32.const 1)) (call $size1 (local.get $M))))
)

(func $getindex (param $M i32) (param $i i32) (param $j i32) (result f32)
  (call $getlinearindex (local.get $M) (call $linearindex (local.get $M) (local.get $i) (local.get $j)))
)

(func $setindex! (param $M i32) (param $x f32) (param $i i32) (param $j i32)
  (call $setlinearindex (local.get $M) (local.get $x) (call $linearindex (local.get $M) (local.get $i) (local.get $j)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 


(func $firstindex (param $v i32) (result i32)
  (i32.const 1)
)

(func $lastindex (param $M i32) (result i32)
  (call $length (local.get $M))
)

;;value,index
(;
(func $iteratearray_init (param $v i32) (result f32 i32) 
(f32.load (i32.add (local.get $v) (i32.const 4)))
(i32.const 1))

(func $iteratearray (param $v i32) (param $i i32) (result f32 i32) 
(f32.load (i32.add (local.get $v) (i32.shl (local.tee $i (i32.add (local.get $i) (i32.const 1))) (i32.const 2))))
(select (local.get $i) (i32.const 0) (i32.le_s (local.get $i) (i32.trunc_f32_s (f32.load $v)))))
;)

;;index, hasmoreitems
(func $iterateunitrange_init (param $n i32) (param $N i32) (result i32 i32)
  (local.get $n)
  (select (i32.const 1) (i32.const 0) (i32.le_s (local.get $n) (local.get $N)))
)

;;index, hasmoreitems
(func $iterateunitrange (param $n i32) (param $N i32) (param $i i32) (result i32 i32)
  (local.tee $i (i32.add (local.get $i) (i32.const 1)))
  (i32.le_s (local.get $i) (local.get $N))
)

(func $gele (param $i i32) (param $n i32) (param $N i32) (result i32)
  ;;n <= i <= N
  (i32.and (i32.ge_s (local.get $i) (local.get $n)) (i32.le_s (local.get $i) (local.get $N)))
)

;;index, hasmoreitems
(func $iteratesteprange_init (param $n i32) (param $k i32) (param $N i32) (result i32 i32)
  (local.get $n)
  (i32.const 1)
)

;;index, hasmoreitems
(func $iteratesteprange (param $n i32) (param $k i32) (param $N i32) (param $i i32) (result i32 i32)
  (local.tee $i (i32.add (local.get $i) (local.get $k)))
  (select (i32.const 1) (i32.const 0) (call $gele (local.get $i) (local.get $n) (local.get $N)))
)

;;i32.min
(func $min (param $a i32) (param $b i32) (result i32)
  (select (local.get $a) (local.get $b) (i32.lt_s (local.get $a) (local.get $b)))
)

;;i32.max
(func $max (param $a i32) (param $b i32) (result i32)
  (select (local.get $a) (local.get $b) (i32.gt_s (local.get $a) (local.get $b)))
)


;;(func $iterategeneralcollection_init (param $v i32) (result i32) (result f32)
;;(func $iterategeneralcollection (param $v i32) (param $i i32) (result i32) (result f32)

;;simple box-mueller randn (using rand, log and cos)
;;TODO: if rand returns exactly 0, this will fail cuz log(0) so do log(max(epsilon,rand())) instead of log(rand())
(func $randn_ (result f32)
  (f32.mul 
    (f32.sqrt (f32.mul (f32.const -2) (call $log (call $rand)))) 
    (call $cos (f32.mul (f32.const 6.283185307179586) (call $rand)))
  )
)

(func $randn (export "randn") (param $a i32) (param $b i32) (result i32)
  (local $C i32) (local $i i32) (local $N i32)
  (local.set $C (call $allocate (local.get $a) (local.get $b)))
  (call $setsize (local.get $C) (local.get $a) (local.get $b))

  (local.set $i (i32.const 1))
  (local.set $N (i32.mul (local.get $a) (local.get $b)))
  (loop 
    (call $setlinearindex (local.get $C) (call $randn_) (local.get $i))
    (br_if 0 (i32.le_s (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $N)))
  )
  (local.get $C)
)

(func $zeros (export "zeros") (param $a i32) (param $b i32) (result i32)
  (local $C i32) (local $i i32) (local $N i32)
  (local.set $C (call $allocate (local.get $a) (local.get $b)))
  (call $setsize (local.get $C) (local.get $a) (local.get $b))

  (local.set $i (i32.const 1))
  (local.set $N (i32.mul (local.get $a) (local.get $b)))
  (loop 
    (call $setlinearindex (local.get $C) (f32.const 0) (local.get $i))
    (br_if 0 (i32.le_s (local.tee $i (i32.add (local.get $i) (i32.const 1))) (local.get $N)))
  )
  (local.get $C)
)

(func $zero (param $M i32) (result i32)
  (call $zeros (call $size1 (local.get $M)) (call $size2 (local.get $M)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; temporary arrays

;;same as setlinearindex_int but always use the pre-allocated temporary array
(func $setlinearindex_int_tmp (param $x i32) (param $i i32)
  (local $M i32)
  (local.set $M (i32.const 4)) ;;the temporary array
  (call $setlinearindex_int (local.get $M) (local.get $x) (local.get $i))
)

(func $setlinearindex_tmp (param $x f32) (param $i i32)
  (local $M i32)
  (local.set $M (i32.const 4)) ;;the temporary array
  (call $setlinearindex (local.get $M) (local.get $x) (local.get $i))
)

(func $setsize_tmp (param $i i32) (param $j i32)
  (local $M i32)
  (local.set $M (i32.const 4)) ;;the temporary array
  (i32.store (local.get $M) (local.get $i))
  (i32.store (i32.add (local.get $M) (i32.const 4)) (local.get $j))
)

)