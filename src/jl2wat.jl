"""
    jl2wat(path::AbstractString)

Convert contents of a julia source code file to WebAssembly text.

# Examples
```julia
julia> using WebAssemblyText
julia> wat = jl2wat(\"example.jl\")
julia> println(wat)
```
"""
function jl2wat(path::AbstractString; debuginfo::Bool=false)
    isfile(path) || return error("No such file: $path")
    str = open(f -> read(f, String), path)
    return jlstring2wat(str; debuginfo=debuginfo)
end

"""
    jlstring2wat(str::AbstractString)

Convert a string of julia source code to WebAssembly text.

# Examples
```julia
julia> using WebAssemblyText
julia> str="
hello(x) = 2.0*x
hello(1.0)
";
julia> wat = jlstring2wat(str);
julia> println(wat)
```
```wat
(module 

(func \$hello (export "hello") (param \$x f32) (result f32)
( return ( f32.mul (f32.const 2.0) (local.get \$x) ) ))
)
```
"""
function jlstring2wat(str::AbstractString; debuginfo::Bool=false)
    try
        result = Base.eval(Evalscope, Meta.parse("begin $str end"))
    catch e
        return e
    end
    
    modulename, imports, funcs, argtypes = blockparse(str)
    SSAs = []
    WATs = []
    processed = Dict()

    # allow for nesting a(b(c())) up to some depth
    maxdepth = 100
    for _ = 1:maxdepth
        for func in keys(argtypes)
            haskey(processed, func) && continue
            ssa, wat = process(func, funcs, argtypes, imports; debuginfo=debuginfo)

            push!(SSAs, ssa)
            push!(WATs, wat)
            processed[func] = true
        end
    end
    
    WATs = joinn([getimports(imports); WATs; getbuiltins(SSAs)...])
    memoryimport = """(memory (import "imports" "memory") 1)"""
    return "(module $modulename\n$memoryimport\n\n$WATs\n)"
end

"""
    process(func, funcs, argtypes)

Get a string with a self contained (func ) expression in .wat format

# Details
The main steps of translating a single function
- type infer func given argtypes[func]
- structure ssa
- update argtypes for other functions called in this function
- translate to wat and inline to a string
- wrap string in a function declaration
"""
function process(func, funcs, argtypes, imports; debuginfo::Bool=false)
    cinfo, Rtype = codeinfo(func, argtypes[func])
    ssa = structure(cinfo.code)
    ssa = [restructure(i, ssa, ssa[i]) for i = 1:length(ssa)]
    wat = [translate(i, cinfo, ssa[i]) for i = 1:length(ssa)]
    wat = inline(wat)
    decl = declaration(cinfo, func, argtypes[func], Rtype)
    wat = parenwrap(decl, wat)
    
    argtypes!(cinfo, argtypes, funcs, ssa)
    imports!(imports, cinfo, funcs, builtinfuncs, ssa)
    
    debuginfo && debugprint(ssa, cinfo)
    
    return ssa, wat
end
