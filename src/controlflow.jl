"""
    addblocks!(i::Integer, ssa::Array, item::Array)

Insert control instructions into ssa.

# Detals
- block, loop, if,
- br, br_if, br_table, return
- unreachable, nop, drop

# Details
- Replace item::GotoNode with "br))" and its target ssa[item.label] with "(block (loop"
- )
"""
function addblocks!(i::Integer, ssa::Array, item)
    if isa(item, GotoNode)
        ssa[item.label] = ["(block (loop"]
        ssa[i] = "br 0))"
        if ssa[item.label - 1][2] == "br_if 1"
            # bit of a hack but for loops will have an extra skip lopp check at [label-1]. remove it if it is there
            ssa[item.label - 1] = [] 
        end
    end
end
addblocks!(i::Integer, ssa::Array, item::Array) = addblocks!.((i,), (ssa,), item)