"""
    getimports(imports::Dict)

Get a .wat string with any used functions that are not builtins or userdefined.

# Details
- a few basic are builtin to wasm. these can be translated.
- other basic functions are bultin to JavaScripts global Math object, these can be imported
- many more are builtin to julia... so they need to be implemented either in .jl, .wat or .js
- give warning if the function cant be imported from js Math.
"""
function getimports(imports::Dict)
    watimports = []
    jsimports = []
    for func in keys(imports)
        push!(watimports, imports[func][1])
        push!(jsimports, imports[func][2])
    end

    if length(jsimports) > 0
        println("INFO: Suggested import object when instantiating WebAssembly from JavaScript:")
        println(jsimportsstring(jsimports))
        println()
    end
    return join(watimports, "\n")
end

function jsimportsstring(jsimports)
    str = ["imports = {\n"]
    for func in jsimports
        push!(str, "  ")
        push!(str, func)
        push!(str, ",\n")
    end
    push!(str, "}")
    return join(str)
end

"""
    jsimportentry(func, argtypes)

Get a string of possible javascript Math module import, assuming it exists in the Math module.

# Details
from a func such as sin, return a string like
\"sin: (x) => Math.sin(x)\"
"""
function jsimportentry(func, argtypes)
    Nparams = length(argtypes)
    
    # the global Math object in js have the same function names as julia has, except for pow and random
    # ofcourse it may not exist in js, but this allows the ones that do to be imported with correct name
    if func == :(^) 
        jsfunc = "pow"
    elseif func == :(rand)
        jsfunc = "random"
    else
        jsfunc = func
    end

    jskey = "\"$(func)\": "
    jsval = " => Math.$(jsfunc)"
    paramnames = []
    for i = 1:Nparams
        push!(paramnames, '`' + i) # unicode char, '`'+1 means a, '`'+2 means b
    end
    pn = join(["("; join(paramnames, ", "); ")"])

    return join([jskey,pn,jsval,pn])
end

isgenericfunction(func) = length(methods(Base.eval(Evalscope, func)).ms)>0
imports!(imports::Dict, ci::CodeInfo, funcs::Dict, builtinfuncs::Dict, item) = nothing
function imports!(imports::Dict, ci::CodeInfo, funcs::Dict, builtinfuncs::Dict, items::Array)
    jsglobalMath = ["^","rand","acos","acosh","asin","asinh","atan","atanh","atan2","cbrt","cos","cosh","exp","expm1","hypot","imul","log","log1p","log10","log2","sign","sin","sinh","tan","tanh","trunc"]

    if isimport(funcs, builtinfuncs, items[1])
        func = items[1]
        if isgenericfunction(func)
            argtypes = itemtype.((ci,), items[2:end])
            ct = code_typed(Base.eval(Evalscope, func), Tuple{argtypes...}; optimize=false, debuginfo=:none)[1]
            cinfo = ct[1]
            Rtype = ct[2]
            imports[func] = [importdeclaration(func.name, argtypes, Rtype), jsimportentry(func.name, argtypes)]

            isavailableinjavascript = string(func.name) in jsglobalMath
            if !isavailableinjavascript
                println("INFO: JavaScript does not have Math.$(func.name). Import your own function instead or write it in julia.")
            end
        end
    end
    imports!.((imports,), (ci,), (funcs,), (builtinfuncs,), items)
end

isimport(funcs, builtinfuncs, item) = false
isimport(funcs, builtinfuncs, item::GlobalRef) = !haskey(builtinfuncs, item.name) && !haskey(funcs, item.name) && !haskey(floatops, item.name) && !haskey(intops, item.name)

function importdeclaration(func, argtypes, Rtype)
    Nparams = length(argtypes)
    paramtypes = [paramtype <: AbstractFloat ? "f32" : "i32" for paramtype in argtypes]

    decl = ["func \$$func (import \"imports\" \"$func\")"]
    for i = 1:Nparams
        push!(decl, "(param \$$('`'+i) $(paramtypes[i]))")
    end
    if !(Rtype <: Nothing) && Rtype <: Number
        rt = Rtype <: AbstractFloat ? "f32" : "i32"
        push!(decl, "(result $rt)")
    end
    decl = join(decl," ")
    return "($decl)"
end