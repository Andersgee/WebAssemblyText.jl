function stringify(ssa::Array)
    ssa = [line for line in ssa if !isnothing(line)]
    return join(spacedjoin.(ssa), "\n")
end

"""
    inlinessarefs(ssa::Array)

Copypaste ssa refs into place and delete used ssa refs. 
"""
function inlinessarefs(ssa::Array)
    usedrefs = []
    usedrefs!(usedrefs, ssa)

    # ssa = addparens.(ssa)
    for (i, line) in enumerate(ssa)
        ssa[i] = replacerefs(ssa, line)
    end
    
    for i in usedrefs
        ssa[i] = [nothing]
    end
    return ssa
end

usedrefs!(refs::Array, item) = isa(item, SSAValue) ? push!(refs, item.id) : nothing
usedrefs!(refs::Array, item::Array) = usedrefs!.((refs,), item)

replacerefs(ssa::Array, item) = isa(item, SSAValue) ? ssa[item.id] : item
replacerefs(ssa::Array, item::Array) = replacerefs.((ssa,), item)

addparens(item) = item
function addparens(items::Array)
    if isnothing(items) || length(items) == 1
        return items
    else
        return ["("; addparens.(items); ")"]
    end
end

spacedjoin(item) = item
spacedjoin(item::Array) = join(spacedjoin.(item), " ")