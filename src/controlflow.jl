"""
    addblocks!(i::Integer, ssa::Array, item::Array)

Insert control instructions into ssa.

# Details
The WebAssembly control instructions are
- blocks: block, if, loop
- branching: br, br_if, return, br_table

# Notes concerning WebAssembly control instructions:
- We do not have Phi nodes (this is why code_typed(optimize=false) is used for producing CodeInfo)
- We do not have arbitrary goto. We can only branch backwards/up the block tree.
- However, branching to a block continues at end of that block, which effectively is a forward jump (aka break)
- Special case: branching to a loop block continues at start of that block (aka continue)
- branching is specified in terms of number of levels (br 0 goes to current block, br 1 goes to parent block and so on. return is essentialy sugar for br MAX)

The strategy is to infer a blocktree from GotoNode
# Notes concerning creating a blocktree
for while loops, if target<i then item::GotoNode
- ssa[item.label] => "(block (loop"
- item.label => "br))"
- )
"""
function addblocks!(ssa::Array, i::Integer, item)
    if isa(item, GotoNode)
        ssa[item.label] = ["(block (loop"]
        ssa[i] = "br 0))"
        if ssa[item.label - 1][2] == "br_if 1"
            # bit of a hack but for loops will have an extra skip lopp check at [label-1]. remove it if it is there
            ssa[item.label - 1] = [] 
        end
    end
end
addblocks!(ssa::Array, i::Integer, items::Array) = addblocks!.((ssa,), (i,), items)



function insertblocks(ssa)

    for (i, line) in enumerate(ssa)
        addblocks!(ssa, i, line)
    end
    return ssa
end
