"""
    blockparse(str::String)

Initial Meta.parse() on entire input. return funcs and initialize Dicts of argtypes and imports.

# Details: 
- funcs: a dict with function,expression as key,values
- argtypes: a dict with with function,argtypes as key,values
- imports: a dict with with function,importstring as key,values
"""
function blockparse(str::String)
    block = pruneLineNumberNode(Meta.parse("begin $str\n end").args)
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

function isfunction(ex::Expr)
    if ex.head == Symbol("function") || ex.head == :(=)
        return true
    else
        return false
    end
end
isfunction(ex) = false

blockfuncnames(block) = [ex.args[1].args[1] for ex in block if isfunction(ex)]
blockfuncexpressions(block) = [ex.args[2] for ex in block if isfunction(ex)]

"""
    codeinfo(func::Symbol, argtypes::Array)

Essentially code_typed() with optimize=false

# Details: 
Not optimizing gives a much simpler AST (without phinodes and boundchecks).
"""
function codeinfo(func, argtypes::Array)
    ct = code_typed(Base.eval(Evalscope, func), Tuple{argtypes...}; optimize=false, debuginfo=:none)[1] # none, source
    cinfo = ct[1]
    Rtype = ct[2]

    #cinfo.slottypes has type Any...

    if (isa(Rtype, Union))
        error("The function $(string(func)) has unstable return type. Rtype: $Rtype")
        #Rtype = getfield(Rtype,2)
        #println("Using one of them for now... Rtype is now $Rtype")
    end
 
    for (i, st) in enumerate(cinfo.slottypes)
        if isa(st, Union)
            types = Base.uniontypes(st) #this is how to get an array of the types. types[2] might be another Union...
            println("uniontypes: ",types)
            if length(types)==2 && types[1] <: Nothing && types[2] <: Tuple{Any, Integer}
                # iterator variables are union of [nothing, [value,index]]
                # types[2] is the [value,index] tuple

                # ignore the nothing field
                # change type of original to the "value" type
                cinfo.slottypes[i] = types[2].parameters[1]
                # and add an extra "index" slot
                push!(cinfo.slotnames, Symbol("_$(i)i"))   
                push!(cinfo.slottypes, types[2].parameters[2])
            else
                #this most likely refers to a variable with an unstable type
                canUseFloat = all(types .<: Number)
                if (canUseFloat)
                    cinfo.slottypes[i] = Float64
                end
                #=
                name = cinfo.slotnames[i]
                cinfo.slottypes[i] = types[1]
                #do I even need to add the extra types?
                for j=2:length(types)
                    push!(cinfo.slotnames, Symbol("_$(name)$(j)"))
                    push!(cinfo.slottypes, types[j])
                end
                =#
            end
        elseif !isa(st, Const) && length(st.parameters) > 1 && istuple(st)
            # wasm can now return multiple values, but tuples dont exist
            # so create individual variables representing the tuple parameters 
            # (but keep the "incorrect" tuple type of the original tuple slot)
            
            for j = 2:length(st.parameters)
                push!(cinfo.slotnames, Symbol("$(cinfo.slotnames[i])$(j)"))
                push!(cinfo.slottypes, st.parameters[j])
            end
            #cinfo.slottypes[i] = st.parameters[1] #actually dont keep the "tuple" type of the first 
        end
        
        # make sure slots have names
        if string(cinfo.slotnames[i]) == ""
            cinfo.slotnames[i] = Symbol("_$i")
        end
    end

    
    for (i, vt) in enumerate(cinfo.ssavaluetypes)
        if isa(vt, Union)  
            cinfo.ssavaluetypes[i] = Tuple{getfield(vt, 2).parameters...}
        elseif isa(vt, Const)
            cinfo.ssavaluetypes[i] = typeof(vt.val)
        elseif isa(vt, PartialStruct)
            cinfo.ssavaluetypes[i] = getfield(vt, 1)
        end
    end
    return cinfo, Rtype
end

# iterator variables are union of [nothing, [value,index]]
isiteratorvariable(st) = isa(st, Union) && getfield(st,1) == Nothing && typeof(getfield(st,2)) == DataType

istuple(slottype) = all([typeof(p) <: DataType for p in slottype.parameters])