"""
    getimports(imports::Dict)

Get a .wat string with any used functions that are not builtins or userdefined.
"""
function getimports(imports::Dict)
    watimports = []
    jsimports = []
    for func in keys(imports)
        push!(watimports, imports[func][1])
        push!(jsimports, imports[func][2])
    end

    if length(jsimports) > 0
        println("INFO: There are assumed imports! The compiled wasm may work by passing this this when instantiating it from JavaScript:")
        println(jsimportsstring(jsimports))
    end
    return join(watimports, "\n")
end

imports!(imports::Dict, ci::CodeInfo, funcs::Dict, builtinfuncs::Dict, item) = nothing
function imports!(imports::Dict, ci::CodeInfo, funcs::Dict, builtinfuncs::Dict, items::Array)
    if isimport(funcs, builtinfuncs, items[1])
        func = items[1]
        argtypes = itemtype.((ci,), items[2:end])
        ct = code_typed(Base.eval(Evalscope, func), Tuple{argtypes...}; optimize=false, debuginfo=:none)[1]
        cinfo = ct[1]
        Rtype = ct[2]

        imports[func] = [importdeclaration(cinfo, func.name, argtypes, Rtype), jsimportentry(cinfo, func.name, argtypes, Rtype)]
    end
    imports!.((imports,), (ci,), (funcs,), (builtinfuncs,), items)
end

isimport(funcs, builtinfuncs, item) = false
isimport(funcs, builtinfuncs, item::GlobalRef) = !haskey(builtinfuncs, item.name) && !haskey(funcs, item.name) && !haskey(floatops, item.name) && !haskey(intops, item.name)

function importdeclaration(cinfo, func, argtypes, Rtype)
    Nparams = length(argtypes)
    slotnames = cinfo.slotnames[2:end]
    slottypes = cinfo.slottypes[2:end]
    slottypes = [slottype <: AbstractFloat ? "f32" : "i32" for slottype in slottypes]

    decl = ["func \$$func (import \"imports\" \"$func\")"]
    for i = 1:length(slotnames)
        if i <= Nparams
            push!(decl, "(param \$$(slotnames[i]) $(slottypes[i]))")
        end
    end
    if !(Rtype <: Nothing) && Rtype <: Number
        rt = Rtype <: AbstractFloat ? "f32" : "i32"
        push!(decl, "(result $rt)")
    end
    return join(["("; decl; ")"], " ")
end

"""
    jsimportentry(cinfo, func, argtypes, Rtype)

Get a string of possible javascript Math module import, assuming it exists in the Math module.

# Details
from a func such as sin, return a string like
\"sin: (x) => Math.sin(x)\"
"""
function jsimportentry(cinfo, func, argtypes, Rtype)
    Nparams = length(argtypes)
    slotnames = cinfo.slotnames[2:end]
    slottypes = cinfo.slottypes[2:end]
    slottypes = [slottype <: AbstractFloat ? "f32" : "i32" for slottype in slottypes]

    jskey = "\"$(func)\": "
    jsval = " => Math.$(func)"
    paramnames = []
    for i = 1:length(slotnames)
        if i <= Nparams
            push!(paramnames, slotnames[i])
        end
    end
    pn = join(["("; join(paramnames, " "); ")"])

    return join([jskey,pn,jsval,pn])
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