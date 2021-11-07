(module
(memory (import "imports" "memory") 1)

(func $console_log (import "imports" "console_log") (param $ptr i32))
(func $console_warn (import "imports" "console_warn") (param $ptr i32))
(func $console_error (import "imports" "console_error") (param $ptr i32))
(func $rand (import "imports" "rand") (result f32))
(func $cos (import "imports" "cos") (param $a f32) (result f32))
(func $log (import "imports" "log") (param $a f32) (result f32))
(func $^ (import "imports" "^") (param $a f32) (param $b f32) (result f32))


(func $muladd (export "muladd") (param $W i32) (param $X i32) (param $b i32) (result i32)
( return ( call $muladd_ ( call $zeros ( call $size1 (local.get $W) ) ( call $size2 (local.get $X) ) ) (local.get $W) (local.get $X) (local.get $b) ) ))

(func $muladd_ (export "muladd_") (param $y i32) (param $W i32) (param $X i32) (param $b i32) (result i32) 
 (local $_6 i32) (local $s f32) (local $szX i32) (local $szW i32) (local $_10 i32) (local $n i32) (local $_12 i32) (local $i i32) (local $j i32) (local $_6i i32) (local $szX2 i32) (local $szW2 i32) (local $_10i i32) (local $_12i i32)
( local.set $szW (local.set $szW2 ( call $size (local.get $W) ) ) )
( local.set $szX (local.set $szX2 ( call $size (local.get $X) ) ) )
( local.set $s (f32.const 0.0) )
( local.set $_6 ( local.set $_6i ( call $iterateunitrange_init (i32.const 1) (local.get $szX2) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_6i) ) ) ) )
(loop
( local.set $n (local.get $_6) )
(local.get $_6i)
( local.set $_10 ( local.set $_10i ( call $iterateunitrange_init (i32.const 1) (local.get $szW) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_10i) ) ) ) )
(loop
( local.set $i (local.get $_10) )
(local.get $_10i)
( local.set $s (f32.const 0.0) )
( local.set $_12 ( local.set $_12i ( call $iterateunitrange_init (i32.const 1) (local.get $szW2) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_12i) ) ) ) )
(loop
( local.set $j (local.get $_12) )
(local.get $_12i)
( local.set $s  ( f32.add (local.get $s) ( f32.mul ( call $getindex (local.get $W) (local.get $i) (local.get $j) ) ( call $getindex (local.get $X) (local.get $j) (local.get $n) ) ) )  )
( local.set $_12 ( local.set $_12i ( call $iterateunitrange (i32.const 1) (local.get $szW2) (local.get $_12) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_12i) ) ) ) )
(br 0)
) )
( call $setindex! (local.get $y) ( f32.add (local.get $s) ( call $getlinearindex (local.get $b) (local.get $i) ) ) (local.get $i) (local.get $n) )
( local.set $_10 ( local.set $_10i ( call $iterateunitrange (i32.const 1) (local.get $szW) (local.get $_10) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_10i) ) ) ) )
(br 0)
) ) ( local.set $_6 ( local.set $_6i ( call $iterateunitrange (i32.const 1) (local.get $szX2) (local.get $_6) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_6i) ) ) ) )
(br 0)
) ) ( return (local.get $y) ))

(func $sum (export "sum") (param $v i32) (result f32) 
 (local $_3 i32) (local $N i32) (local $s f32) (local $i i32) (local $_3i i32)
( local.set $s (f32.const 0.0) )
( local.set $N  ( call $length (local.get $v) )  )
( local.set $_3 ( local.set $_3i ( call $iterateunitrange_init (i32.const 1) (local.get $N) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_3i) ) ) ) )
(loop
( local.set $i (local.get $_3) )
(local.get $_3i)
( local.set $s  ( f32.add (local.get $s) ( call $getlinearindex (local.get $v) (local.get $i) ) )  )
( local.set $_3 ( local.set $_3i ( call $iterateunitrange (i32.const 1) (local.get $N) (local.get $_3) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_3i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

(func $add (export "add") (param $a i32) (param $b i32) (result i32)
( return ( call $add_ ( call $zeros ( call $size (local.get $a) ) ) (local.get $a) (local.get $b) ) ))

(func $mul (export "mul") (param $W i32) (param $X i32) (result i32)
( return ( call $mul_ ( call $zeros ( call $size1 (local.get $W) ) ( call $size2 (local.get $X) ) ) (local.get $W) (local.get $X) ) ))

(func $tuplecall (export "tuplecall") (param $x f32) (result f32) 
 (local $r f32) (local $ab f32) (local $ab2 f32)
( local.set $ab (local.set $ab2 ( call $tuplereturn (local.get $x) ) ) )
( local.set $r  (local.get $ab)  )
( return (local.get $r) ))

(func $add_ (export "add_") (param $r i32) (param $a i32) (param $b i32) (result i32) 
 (local $_5 i32) (local $N i32) (local $i i32) (local $_5i i32)
( local.set $N  ( call $length (local.get $r) )  )
( local.set $_5 ( local.set $_5i ( call $iterateunitrange_init (i32.const 1) (local.get $N) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_5i) ) ) ) )
(loop
( local.set $i (local.get $_5) )
(local.get $_5i)
( call $setlinearindex (local.get $r) ( f32.add ( call $getlinearindex (local.get $a) (local.get $i) ) ( call $getlinearindex (local.get $b) (local.get $i) ) ) (local.get $i) )
( local.set $_5 ( local.set $_5i ( call $iterateunitrange (i32.const 1) (local.get $N) (local.get $_5) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_5i) ) ) ) )
(br 0)
) ) ( return (local.get $r) ))

(func $dot (export "dot") (param $a i32) (param $b i32) (result f32) 
 (local $_4 i32) (local $N i32) (local $s f32) (local $i i32) (local $_4i i32)
( local.set $s (f32.const 0.0) )
( local.set $N  ( call $length (local.get $a) )  )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange_init (i32.const 1) (local.get $N) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_4i) ) ) ) )
(loop
( local.set $i (local.get $_4) )
(local.get $_4i)
( local.set $s  ( f32.add (local.get $s) ( f32.mul ( call $getlinearindex (local.get $a) (local.get $i) ) ( call $getlinearindex (local.get $b) (local.get $i) ) ) )  )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange (i32.const 1) (local.get $N) (local.get $_4) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_4i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

(func $tuplereturn (export "tuplereturn") (param $x f32) (result f32) (result f32) 
 (local $b f32) (local $a f32)
( local.set $a  ( f32.mul (local.get $x) (f32.const 1.2) )  )
( local.set $b  ( f32.mul (local.get $x) (f32.const 1.3) )  )
( return (local.get $a) (local.get $b) ))

(func $mul_ (export "mul_") (param $y i32) (param $W i32) (param $X i32) (result i32) 
 (local $_5 i32) (local $s f32) (local $szX i32) (local $szW i32) (local $_9 i32) (local $n i32) (local $_11 i32) (local $i i32) (local $j i32) (local $_5i i32) (local $szX2 i32) (local $szW2 i32) (local $_9i i32) (local $_11i i32)
( local.set $szW (local.set $szW2 ( call $size (local.get $W) ) ) )
( local.set $szX (local.set $szX2 ( call $size (local.get $X) ) ) )
( local.set $s (f32.const 0.0) )
( local.set $_5 ( local.set $_5i ( call $iterateunitrange_init (i32.const 1) (local.get $szX2) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_5i) ) ) ) )
(loop
( local.set $n (local.get $_5) )
(local.get $_5i)
( local.set $_9 ( local.set $_9i ( call $iterateunitrange_init (i32.const 1) (local.get $szW) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_9i) ) ) ) )
(loop
( local.set $i (local.get $_9) )
(local.get $_9i)
( local.set $s (f32.const 0.0) )
( local.set $_11 ( local.set $_11i ( call $iterateunitrange_init (i32.const 1) (local.get $szW2) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_11i) ) ) ) )
(loop
( local.set $j (local.get $_11) )
(local.get $_11i)
( local.set $s  ( f32.add (local.get $s) ( f32.mul ( call $getindex (local.get $W) (local.get $i) (local.get $j) ) ( call $getindex (local.get $X) (local.get $j) (local.get $n) ) ) )  )
( local.set $_11 ( local.set $_11i ( call $iterateunitrange (i32.const 1) (local.get $szW2) (local.get $_11) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_11i) ) ) ) )
(br 0)
) ) ( call $setindex! (local.get $y) (local.get $s) (local.get $i) (local.get $n) )
( local.set $_9 ( local.set $_9i ( call $iterateunitrange (i32.const 1) (local.get $szW) (local.get $_9) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_9i) ) ) ) )
(br 0)
) ) ( local.set $_5 ( local.set $_5i ( call $iterateunitrange (i32.const 1) (local.get $szX2) (local.get $_5) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_5i) ) ) ) )
(br 0)
) ) ( return (local.get $y) ))

(func $scalaradd (export "scalaradd") (param $a f32) (param $b f32) (result f32)
( return ( f32.add (local.get $a) (local.get $b) ) ))

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