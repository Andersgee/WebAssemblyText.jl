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
    # str = open(f -> read(f, String), path)
    str = read(path, String)
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
function jlstring2wat(str::AbstractString; debuginfo::Bool=false, barebone::Bool=false)
    try
        result = Base.eval(Evalscope, Meta.parse("begin $str\n end"))
    catch e
        #return e
        errorstring = "$(typeof(e)): $(e.msg)"
        println(errorstring)
        return errorstring 
    end
    
    funcs, argtypes, imports = blockparse(str)
    SSAs = []
    WATs = []
    processed = Dict()

    # allow for nesting a(b(c())) up to some depth
    maxdepth = 100
    for _ = 1:maxdepth
        for func in keys(argtypes)
            haskey(processed, func) && continue
            ssa, wat = process(func, funcs, argtypes, imports; debuginfo=debuginfo)

            if func != Symbol("exports")
                push!(SSAs, ssa)
                push!(WATs, wat)
            end
            processed[func] = true
        end
    end

    if (barebone)
        #Dont add on the stuff that would make it compileable.
        return joinn(WATs)
    end
    
    # WATs = joinn([getimports(imports); WATs; getbuiltins(SSAs)...])
    WATs = joinn([getimports(imports); WATs; getallbuiltins()])
    memoryimport = """(memory (import "imports" "memory") 1)"""
    default_jsimports = raw"""(func $console_log (import "imports" "console_log") (param $ptr i32))
    (func $console_warn (import "imports" "console_warn") (param $ptr i32))
    (func $console_error (import "imports" "console_error") (param $ptr i32))
    (func $rand (import "imports" "rand") (result f32))
    (func $cos (import "imports" "cos") (param $a f32) (result f32))
    (func $log (import "imports" "log") (param $a f32) (result f32))
    (func $^ (import "imports" "^") (param $a f32) (param $b f32) (result f32))"""
    return """(module\n$memoryimport\n\n$default_jsimports\n$WATs\n)"""
end

getallbuiltins() = open(f -> read(f, String), joinpath(@__DIR__, "builtins.wat"))

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
    
    #debuginfo && debugprint(ssa, cinfo, binfo)
    #debugprint(ssa, cinfo, blockinfo(ssa))
    
    ssa = [restructure(cinfo, i, ssa, ssa[i]) for i = 1:length(ssa)]
    binfo = blockinfo(ssa)
    
    printstyled("---------- $func (after restructure) ----------\n"; color=:yellow)
    debugprint(ssa, cinfo, binfo, Rtype)
    
    argtypes!(cinfo, argtypes, funcs, ssa)
    imports!(imports, cinfo, funcs, builtinfuncs, ssa)
    
    ssa = inlinessarefs(ssa)
    wat = [translate(i, cinfo, ssa[i]) for i = 1:length(ssa)]
    wat = [translate_gotos(binfo, i, wat[i]) for i = 1:length(wat)]
    
    wat = addparens.(wat)
    wat = addblocks(binfo, wat)
    wat = stringify(wat)
    decl = declaration(cinfo, func, argtypes[func], Rtype)
    wat = parenwrap(decl, wat)
    return ssa, wat
end

"""
    @code_wat expression

Macro for translating a single function without adding on imports and builtins.

# Examples

```julia
julia> hello(x) = 3.1*x
julia> @code_wat hello(1.2)

(func \$hello (export "hello") (param \$x f32) (result f32) 
(return (f32.mul (f32.const 3.1) (local.get \$x))))
```
"""
macro code_wat(ex)
    :(code_wat($(esc(ex.args[1])), $(ex.args[2:end])))
end

function code_wat(func, args)
    types = typeof.([Base.eval(Evalscope, arg) for arg in args])
    imports = Dict()
    funcs = Dict(func => func)
    argtypes = Dict(func => types)

    ssa, wat = process(func, funcs, argtypes, imports)
    return println(wat)
end



"""
    jlstring2wat_barebone(str::AbstractString)

Same as jlstring2wat but without adding on imports and builtins.
"""
function jlstring2wat_barebone(str::AbstractString; debuginfo::Bool=false)
    return jlstring2wat(str; debuginfo=debuginfo, barebone=true )
end