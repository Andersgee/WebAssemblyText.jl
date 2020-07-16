"""
    topexpressions(str::String)

Meta.parse() on entire input. return funcs, argtypes.
- funcs: a dict with function,expression as key,values
- argtypes: a dict with with function,argtypes as key,values

argtypes will not be known for all funcs right away.
"""
function blockparse(str::String)
    block = arrayify(Meta.parse("begin $str end").args)
    display(block)
    if block[1][1] == Symbol("module")
        modulename = block[1][3]
        block = block[1][4]
    else
        modulename = ""
    end

    funcs = Dict(blockfuncnames(block) .=> blockfuncexpressions(block))
    
    argtypes = Dict()
    for ex in block
        if ex[1] == :(call)
            argtypes[ex[2]] = length(ex) > 2 ? typeof.(ex[3:end]) : []
        end
    end
    imports = Dict()
    return modulename, imports, funcs, argtypes
end

"""
    arrayify(items)

Remove LineNumberNodes and turn expressions to arrays

# Details
a string like
```julia
m = 67.1
p(a) = 3.0*a
function kek(x)
    a = 3.1
    return x*2.0 + m*a
end
kek(3.0)
```
will be arrayify(Meta.parse("begin \$str end").args) into
```
[:(=), :m, 67.1]
[:(=), [:call, :p, :a], [[:call, :*, 3.0, :a]]]
[:function, [:call, :kek, :x], [[:return, [:call, :+, [:call, :*, :x, 2.0], :m]]]]
[:call, :kek, 3.0]
```
"""
arrayify(item) = item
arrayify(items::Array) = [arrayify(item) for item in items if !isa(item, LineNumberNode)]
arrayify(item::Expr) = item.head == :(block) ? arrayify(item.args) : [item.head; arrayify(item.args)]

isfunction(ex::Array) = (ex == Symbol("function") || ex[1] == :(=)) && isa(ex[2],Array) && ex[2][1] == :(call)
isfunction(ex) = false

blockfuncnames(block) = [ex[2][2] for ex in block if isfunction(ex)]
blockfuncexpressions(block) = [[ex[3]][1] for ex in block if isfunction(ex)]
"""
    codeinfo(func::Symbol, argtypes::Array)

Essentially code_typed() with optimize=false

# Details: 
Not optimizing complicates type inference, but ultimately simplifies
translation becuase the returned CodeInfo is much cleaner.

Also, we have to modifiy CodeInfo by
- making sure sure slotnames contain names
- making sure slottypes and ssavaluetypes contain types

this has mostly to do with iterator variables
"""
function codeinfo(func, argtypes::Array)
    ct = code_typed(Base.eval(Evalscope, func), Tuple{argtypes...}; optimize=false, debuginfo=:none)[1] # none, source
    cinfo = ct[1]
    Rtype = ct[2]
    length(Rtype.parameters) > 1 && error("WebAssembly only allow functions to return a single number or nothing. function $func returns $Rtype")

    for (i, st) in enumerate(cinfo.slottypes)
        if isa(st, Union) # aka iterator variable
            cinfo.slotnames[i] = Symbol("_$i")
            cinfo.slottypes[i] = getfield(st, 2).parameters[1]
        end
    end
    
    for (i, vt) in enumerate(cinfo.ssavaluetypes)
        if isa(vt, Compiler.Const)
            if typeof(vt.val) <: OrdinalRange
                cinfo.ssavaluetypes[i] = typeof(vt.val[1])
            else
                cinfo.ssavaluetypes[i] = typeof(vt.val)
            end
        elseif isa(vt, Union)
            cinfo.ssavaluetypes[i] = getfield(vt, 2).parameters[1]
        elseif isa(vt, DataType) && length(vt.parameters) > 1
            cinfo.ssavaluetypes[i] = vt.parameters[1]
        end
    end

    return cinfo, Rtype
end
