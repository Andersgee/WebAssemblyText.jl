"""
    declaration(cinfo, func, argtypes, Rtype)

Get a wat string with function declaration.
"""
function declaration(cinfo, func, argtypes, Rtype)
    Nparams = length(argtypes)
    slotnames = cinfo.slotnames[2:end]
    slottypes = cinfo.slottypes[2:end]
    slottypes = get_slottypes(slottypes)

    decl = ["func \$$func (export \"$func\")"]
    locals = []
    for i = 1:length(slotnames)
        if i <= Nparams
            push!(decl, "(param \$$(slotnames[i]) $(slottypes[i]))")
        else
            push!(locals, "(local \$$(slotnames[i]) $(slottypes[i]))")
        end
    end

    ret = [] 
    if length(Rtype.parameters) > 0
        #isarray = Rtype == Array{Float64,1}
        isarray = Rtype <: Array
        if isarray
            push!(ret, "(result i32)")
        else
            # DataType Tuple
            for rtype in Rtype.parameters
                if !(rtype <: Nothing)
                    rt = rtype <: AbstractFloat ? "f32" : "i32"
                    push!(ret, "(result $rt)")
                end
            end
        end
    else
        # DataType 
        if !(Rtype <: Nothing)
            rt = Rtype <: AbstractFloat ? "f32" : "i32"
            push!(ret, "(result $rt)")
        end
    end
    
    if length(locals)>0
        return join([decl; ret; "\n"; locals], " ")
    else
        return join([decl; ret], " ")
    end 
end

function get_slottypes(slottypes)
    st = []
    for slottype in slottypes
        if slottype <: AbstractFloat
            push!(st, "f32")
        elseif length(slottype.parameters) > 1 && istuple(slottype)
            t = slottype.parameters[1] <: AbstractFloat ? "f32" : "i32"
            push!(st, t)
        else
            push!(st, "i32")
        end
    end
    return st
end