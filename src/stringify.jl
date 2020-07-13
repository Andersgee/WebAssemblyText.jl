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
function inline(ssa::Array)
    usedrefs = []
    usedrefs!(usedrefs, ssa)

    ssa = addparens.(ssa)
    for (i, line) in enumerate(ssa)
        ssa[i] = replacerefs(ssa, line)
    end
    
    for i in usedrefs
        ssa[i] = []
    end
    
    for (i, line) in enumerate(ssa)
        addblocks!(i, ssa, line)
    end
    
    clean_ssa = [line for line in ssa if !isa(line, Nothing) && length(line) > 0]

    return join(spacedjoin.(clean_ssa), "\n")
end

usedrefs!(refs::Array, item) = isa(item, SSAValue) ? push!(refs, item.id) : nothing
usedrefs!(refs::Array, item::Array) = usedrefs!.((refs,), item)

replacerefs(ssa::Array, item) = isa(item, SSAValue) ? ssa[item.id] : item
replacerefs(ssa::Array, item::Array) = replacerefs.((ssa,), item)

addparens(item) = item
addparens(item::Array) = ["("; addparens.(item); ")"]

spacedjoin(item) = item
spacedjoin(item::Array) = join(spacedjoin.(item), " ")