"""
    blockparse(str::String)

Initial Meta.parse() on entire input. return funcs and initialize Dicts of argtypes and imports.

# Details: 
- funcs: a dict with function,expression as key,values
- argtypes: a dict with with function,argtypes as key,values
- imports: a dict with with function,importstring as key,values
"""
function blockparse(str::String)
    block = pruneLineNumberNode(Meta.parse("begin $str end").args)
    funcs = Dict(blockfuncnames(block) .=> blockfuncexpressions(block))
    argtypes = Dict()
    imports = Dict()

    # fill in top level argtypes for function calls
    for ex in block
        if ex.head == :(call)
            name = ex.args[1]
            args = ex.args[2:end]
            # typeof(eval(arg)) instead of typeof(arg) allows top level call with rand() etc.
            types = typeof.([Base.eval(Evalscope, arg) for arg in args])
            argtypes[name] = types
        end
    end
    return funcs, argtypes, imports
end


pruneLineNumberNode(item) = item
pruneLineNumberNode(items::Array) = [pruneLineNumberNode(item) for item in items if !isa(item, LineNumberNode)]
pruneLineNumberNode(item::Expr) = item.head == :(block) ? pruneLineNumberNode(item.args) : Expr(item.head, pruneLineNumberNode(item.args)...)

isfunction(ex::Expr) = ex.head == Symbol("function") || ex.head == :(=)
isfunction(ex) = false

blockfuncnames(block) = [ex.args[1].args[1] for ex in block if isfunction(ex)]
blockfuncexpressions(block) = [ex.args[2] for ex in block if isfunction(ex)]

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
            # iterators are either nothing or state (which is a tuple of [value,index])
            # so getfield 2 gets state types
            cinfo.slottypes[i] = getfield(st, 2).parameters[1] # valtype
            
            # because we cant have tuples. use 2 locals for iterator variables
            push!(cinfo.slotnames, Symbol("_$(i)bool"))
            push!(cinfo.slottypes, getfield(st, 2).parameters[2])
        end
        if string(cinfo.slotnames[i]) == ""
            cinfo.slotnames[i] = Symbol("_$i")
        end
    end

    
    for (i, vt) in enumerate(cinfo.ssavaluetypes)
        if isa(vt, Union)
            #cinfo.ssavaluetypes[i] = getfield(vt, 2).parameters[1]
            #cinfo.ssavaluetypes[i] = getfield(vt, 2).parameters
            cinfo.ssavaluetypes[i] = Tuple{Int, Int} #handle iterator variables as [index,notempty] instead of union ([value,index], nothing)
        elseif isa(vt, Compiler.Const)
            cinfo.ssavaluetypes[i] = typeof(vt.val)
        elseif isa(vt, PartialStruct)
            #println("PartialStruct: ",vt)
            cinfo.ssavaluetypes[i] = getfield(vt,1)
        #=
        elseif isa(vt, Compiler.Const)
            if typeof(vt.val) <: OrdinalRange
                cinfo.ssavaluetypes[i] = typeof(vt.val[1])
            else
                cinfo.ssavaluetypes[i] = typeof(vt.val)
            end
        elseif isa(vt, DataType) && length(vt.parameters) > 1
            cinfo.ssavaluetypes[i] = vt.parameters[1]
        =#
        end
    end

    return cinfo, Rtype
end
