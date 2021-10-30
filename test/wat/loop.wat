(module(memory (import "imports" "memory") 1)

(func $console_log (import "imports" "console_log") (param $ptr i32))
(func $console_warn (import "imports" "console_warn") (param $ptr i32))
(func $console_error (import "imports" "console_error") (param $ptr i32))
(func $rand (import "imports" "rand") (result f32))
(func $cos (import "imports" "cos") (param $a f32) (result f32))
(func $log (import "imports" "log") (param $a f32) (result f32))
(func $^ (import "imports" "^") (param $a f32) (param $b f32) (result f32))


(func $_unitrange (export "_unitrange") (param $start i32) (param $stop i32) (result f32) 
 (local $_4 i32) (local $s f32) (local $i i32) (local $_4i i32)
( local.set $s (f32.const 0.0) )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange_init (local.get $start) (local.get $stop) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_4i) ) ) ) )
(loop
( local.set $i (local.get $_4) )
(local.get $_4i)
( local.set $s  ( f32.add (local.get $s) (f32.const 2.1) )  )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange (local.get $start) (local.get $stop) (local.get $_4) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_4i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

(func $_while (export "_while") (param $n i32) (result f32) 
 (local $i i32) (local $s f32)
( local.set $s (f32.const 0.0) )
( local.set $i (i32.const 1) )
(block (loop
( br_if 1 ( i32.eqz ( i32.lt_s (local.get $i) (local.get $n) ) ) )
( local.set $s  ( f32.add (local.get $s) (f32.const 2.1) )  )
( local.set $i  ( i32.add (local.get $i) (i32.const 1) )  )
(br 0)
) ) ( return (local.get $s) ))

(func $_steprange (export "_steprange") (param $start i32) (param $step i32) (param $stop i32) (result f32) 
 (local $_5 i32) (local $s f32) (local $i i32) (local $_5i i32)
( local.set $s (f32.const 0.0) )
( local.set $_5 ( local.set $_5i ( call $iteratesteprange_init (local.get $start) (local.get $step) (local.get $stop) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_5i) ) ) ) )
(loop
( local.set $i (local.get $_5) )
(local.get $_5i)
( local.set $s  ( f32.add (local.get $s) (f32.const 2.1) )  )
( local.set $_5 ( local.set $_5i ( call $iteratesteprange (local.get $start) (local.get $step) (local.get $stop) (local.get $_5) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_5i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

(func $_unitrange2 (export "_unitrange2") (param $start i32) (param $stop i32) (result f32) 
 (local $_4 i32) (local $s f32) (local $i i32) (local $_4i i32)
( local.set $s (f32.const 0.0) )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange_init (local.get $start) (local.get $stop) ) ) )
(block ( br_if 0 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_4i) ) ) ) )
(loop
( local.set $i (local.get $_4) )
(local.get $_4i)
( local.set $s  ( f32.add ( f32.convert_i32_s (local.get $i) ) ( f32.add (local.get $s) (f32.const 2.1) ) )  )
( local.set $_4 ( local.set $_4i ( call $iterateunitrange (local.get $start) (local.get $stop) (local.get $_4) ) ) )
( br_if 1 ( i32.eqz ( i32.eqz ( i32.eqz (local.get $_4i) ) ) ) )
(br 0)
) ) ( return (local.get $s) ))

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