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

# Details:
cant use types such as Bool or Nothing or multiple return values 
wasm does comparison as ints with i32.const 0 meaning false
so :(iterate) have to return 0 instead of false when iterator is empty, which is an issue when iterating across zero.
"""
builtinfuncs = Dict(
:(iterate) => """(func \$iterate (param \$n i32) (param \$k i32) (param \$N i32) (param \$i i32) (result i32) (result i32)
(local.tee \$i (i32.add (local.get \$i) (local.get \$k)))
(i32.and (i32.le_s (local.get \$i) (local.get \$N)) (i32.ge_s (local.get \$i) (local.get \$n))))""",
:(getindex) => """(func \$getindex (param \$v i32) (param \$i i32) (result f32)
(f32.load (i32.add (local.get \$v) (i32.shl (local.get \$i) (i32.const 2)))))""",
:(setindex!) => """(func \$setindex! (param \$v i32) (param \$x f32) (param \$i i32)
(f32.store (i32.add (local.get \$v) (i32.shl (local.get \$i) (i32.const 2))) (local.get \$x)))""",
:(firstindex) => """(func \$firstindex (param \$v i32) (result i32)
(i32.const 1))""",
:(lastindex) => """(func \$lastindex (param \$v i32) (result i32)
(i32.trunc_f32_s (f32.load (local.get \$v))))""",
:(length) => """(func \$length (param \$v i32) (result i32)
(i32.trunc_f32_s (f32.load (local.get \$v))))""",
)

# TODO
# https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-array-1