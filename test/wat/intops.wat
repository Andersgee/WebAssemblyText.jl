(module
(memory (import "imports" "memory") 1)

(func $console_log (import "imports" "console_log") (param $ptr i32))
(func $console_warn (import "imports" "console_warn") (param $ptr i32))
(func $console_error (import "imports" "console_error") (param $ptr i32))
(func $rand (import "imports" "rand") (result f32))
(func $cos (import "imports" "cos") (param $a f32) (result f32))
(func $log (import "imports" "log") (param $a f32) (result f32))
(func $^ (import "imports" "^") (param $a f32) (param $b f32) (result f32))


(func $ops (export "ops") (param $a i32) (param $b i32) 
 (local $f i32) (local $t i32)
( call $add (local.get $a) (local.get $b) )
( call $sub (local.get $a) (local.get $b) )
( call $mul (local.get $a) (local.get $b) )
( call $_div (local.get $a) (local.get $b) )
( call $_div2 (local.get $a) (local.get $b) )
( call $_shl (local.get $a) (local.get $b) )
( call $_shr (local.get $a) (local.get $b) )
( call $_eq (local.get $a) (local.get $b) )
( call $_egal (local.get $a) (local.get $b) )
( call $_ne (local.get $a) (local.get $b) )
( call $_lt (local.get $a) (local.get $b) )
( call $_gt (local.get $a) (local.get $b) )
( call $_le (local.get $a) (local.get $b) )
( call $_ge (local.get $a) (local.get $b) )
( call $_leading_zeros (local.get $a) )
( call $_trailing_zeros (local.get $a) )
( call $_count_ones (local.get $a) )
( call $_float (local.get $a) )
( call $_mod (local.get $a) (local.get $b) )
( call $_mod2 (local.get $a) (local.get $b) )
( local.set $t (i32.const 1) )
( local.set $f (i32.const 0) )
( call $_and (i32.const 1) (i32.const 0) )
( call $_or (i32.const 1) (i32.const 0) )
( call $_xor (i32.const 1) (i32.const 0) )
( call $_xor2 (i32.const 1) (i32.const 0) )
( call $_not (i32.const 1) )
return)

(func $_gt (export "_gt") (param $a i32) (param $b i32) (result i32)
( return ( i32.gt_s (local.get $a) (local.get $b) ) ))

(func $_ne (export "_ne") (param $a i32) (param $b i32) (result i32)
( return ( i32.ne (local.get $a) (local.get $b) ) ))

(func $add (export "add") (param $a i32) (param $b i32) (result i32)
( return ( i32.add (local.get $a) (local.get $b) ) ))

(func $_trailing_zeros (export "_trailing_zeros") (param $a i32) (result i32)
( return ( i32.ctz (local.get $a) ) ))

(func $_mod2 (export "_mod2") (param $a i32) (param $b i32) (result i32)
( return ( i32.rem_s (local.get $a) (local.get $b) ) ))

(func $_leading_zeros (export "_leading_zeros") (param $a i32) (result i32)
( return ( i32.clz (local.get $a) ) ))

(func $_shr (export "_shr") (param $a i32) (param $b i32) (result i32)
( return ( i32.shr_s (local.get $a) (local.get $b) ) ))

(func $_egal (export "_egal") (param $a i32) (param $b i32) (result i32)
( return ( i32.eq (local.get $a) (local.get $b) ) ))

(func $_eq (export "_eq") (param $a i32) (param $b i32) (result i32)
( return ( i32.eq (local.get $a) (local.get $b) ) ))

(func $_div (export "_div") (param $a i32) (param $b i32) (result i32)
( return ( i32.div_s (local.get $a) (local.get $b) ) ))

(func $_le (export "_le") (param $a i32) (param $b i32) (result i32)
( return ( i32.le_s (local.get $a) (local.get $b) ) ))

(func $_not (export "_not") (param $a i32) (result i32)
( return ( i32.eqz (local.get $a) ) ))

(func $sub (export "sub") (param $a i32) (param $b i32) (result i32)
( return ( i32.sub (local.get $a) (local.get $b) ) ))

(func $_div2 (export "_div2") (param $a i32) (param $b i32) (result f32)
( return ( f32.div (f32.convert_i32_s (local.get $a) ) (f32.convert_i32_s (local.get $b) ) ) ))

(func $_float (export "_float") (param $a i32) (result f32)
( return ( f32.convert_i32_s (local.get $a) ) ))

(func $_xor (export "_xor") (param $a i32) (param $b i32) (result i32)
( return ( i32.xor (local.get $a) (local.get $b) ) ))

(func $_lt (export "_lt") (param $a i32) (param $b i32) (result i32)
( return ( i32.lt_s (local.get $a) (local.get $b) ) ))

(func $_shl (export "_shl") (param $a i32) (param $b i32) (result i32)
( return ( i32.shl (local.get $a) (local.get $b) ) ))

(func $_xor2 (export "_xor2") (param $a i32) (param $b i32) (result i32)
( return ( i32.xor (local.get $a) (local.get $b) ) ))

(func $_mod (export "_mod") (param $a i32) (param $b i32) (result i32)
( return ( i32.rem_s (local.get $a) (local.get $b) ) ))

(func $_ge (export "_ge") (param $a i32) (param $b i32) (result i32)
( return ( i32.ge_s (local.get $a) (local.get $b) ) ))

(func $mul (export "mul") (param $a i32) (param $b i32) (result i32)
( return ( i32.mul (local.get $a) (local.get $b) ) ))

(func $_count_ones (export "_count_ones") (param $a i32) (result i32)
( return ( i32.popcnt (local.get $a) ) ))

(func $_or (export "_or") (param $a i32) (param $b i32) (result i32)
(block ( br_if 0 ( i32.eqz (local.get $a) ) )
( return (local.get $a) )
) ( return (local.get $b) ))

(func $_and (export "_and") (param $a i32) (param $b i32) (result i32)
(block ( br_if 0 ( i32.eqz (local.get $a) ) )
( return (local.get $b) )
) ( return (i32.const 0) ))

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