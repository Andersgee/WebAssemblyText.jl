"""
    inline(ssa::Array)

Get a wat single string from a an already translated ssa.

# Details:
- Get a list of ssa references
- Add parenthesis
- Replace refs by the referenced lines
- Delete the referenced lines
- add block and loop control flow based on GotoNodes
- Join.
"""
function stringify(ssa::Array)
    ssa = [line for line in ssa if !isnothing(line)]
    return join(spacedjoin.(ssa), "\n")
end

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
addparens(item::Array) = isnothing(item) || length(item) == 1 ? item : ["("; addparens.(item); ")"]

spacedjoin(item) = item
spacedjoin(item::Array) = join(spacedjoin.(item), " ")