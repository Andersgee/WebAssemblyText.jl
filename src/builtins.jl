"""
    getbuiltins(ssa::Array)

Get an array of strings with any used builtin .wat functions as specified by the dict builtinfuncs.
"""
function getbuiltins(ssa::Array)
    builtins = Dict()
    builtins!(builtins, ssa)
    return values(builtins)
end

builtins!(builtins, item) = isbuiltin(item) ? builtins[item.name] = builtinfuncs[item.name] : nothing
builtins!(builtins, items::Array) = builtins!.((builtins,), items)

isbuiltin(item) = false
isbuiltin(item::GlobalRef) = haskey(builtinfuncs, item.name)

"""
builtinfuncs: a dict with handwritten .wat of some julia builtins.
"""
builtinfuncs = Dict(
:(zero) => "wat",
:(zeros) => "wat",
:(randn) => "wat",
:(copy) => "wat",
:(min) => "wat",
:(max) => "wat",
:(size) => "wat",
:(getindex) => raw"""(func $getindex (param $v i32) (param $i i32) (result f32)
(f32.load (i32.add (local.get $v) (i32.shl (local.get $i) (i32.const 2)))))""",
:(setindex!) => raw"""(func $setindex! (param $v i32) (param $x f32) (param $i i32)
(f32.store (i32.add (local.get $v) (i32.shl (local.get $i) (i32.const 2))) (local.get $x)))""",
:(firstindex) => raw"""(func $firstindex (param $v i32) (result i32)
(i32.const 1))""",
:(lastindex) => raw"""(func $lastindex (param $v i32) (result i32)
(i32.trunc_f32_s (f32.load (local.get $v))))""",
:(length) => raw"""(func $length (param $v i32) (result i32)
(i32.trunc_f32_s (f32.load (local.get $v))))""",
:(iteratearray_init) => raw"""(func $iteratearray_init (param $v i32) (result f32 i32) 
(f32.load (i32.add (local.get $v) (i32.const 4)))
(i32.const 1))""",
:(iteratearray) => raw"""(func $iteratearray (param $v i32) (param $i i32) (result f32 i32) 
(f32.load (i32.add (local.get $v) (i32.shl (local.tee $i (i32.add (local.get $i) (i32.const 1))) (i32.const 2))))
(select (local.get $i) (i32.const 0) (i32.le_s (local.get $i) (i32.trunc_f32_s (f32.load $v)))))""",
:(iterateunitrange_init) => raw"""(func $iterateunitrange_init (param $n i32) (param $N i32) (result i32 i32)
(local.get $n)
(select (i32.const 1) (i32.const 0) (i32.le_s (local.get $n) (local.get $N))))""",
:(iterateunitrange) => raw"""(func $iterateunitrange (param $n i32) (param $N i32) (param $i i32) (result i32 i32)
(local.tee $i (i32.add (local.get $i) (i32.const 1)))
(i32.le_s (local.get $i) (local.get $N)))""",
:(iteratesteprange_init) => raw"""(func $iteratesteprange_init (param $n i32) (param $k i32) (param $N i32) (result i32 i32)
(local.get $n) (i32.const 1))""",
:(iteratesteprange) => raw"""(func $iteratesteprange (param $n i32) (param $k i32) (param $N i32) (param $i i32) (result i32 i32)
(local.tee $i (i32.add (local.get $i) (local.get $k)))
(select (i32.const 1) (i32.const 0) (i32.and (i32.ge_s (local.get $i) (local.get $n)) (i32.le_s (local.get $i) (local.get $N)))))""",
:(iteratecollection_init) => raw"""(func $iteratecollection_init (param $v i32) (result i32) (result f32)
TODO
""",
:(iteratecollection) => raw"""(func $iteratecollection (param $v i32) (param $i i32) (result i32) (result f32)
TODO
"""
)

# TODO
# https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-array-1