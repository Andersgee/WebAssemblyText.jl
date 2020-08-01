"""
    blockinfo(ssa::Array)

Infer a tree of WebAssembly blocks from ssa and return a BlockInfo struct containing
- a goto dict
- a list of which blocks each ssa index is a child of.

# Details
WebAssembly control instructions (mainly) consist of
- blocks: block, loop
- branching: br, br_if, return

# Notes concerning WebAssembly control instructions:
- We do not have Phi nodes (a block can only have one parent)
- We do not have gotos/jumps. We can only branch backwards/up the block tree.
- However, branching to a block continues at end of that block, which effectively is a forward jump (aka break)
- Special case: branching to a loop block continues at start of that block (aka continue)
- branching is specified in terms of number of levels up (br 0 goes to current block, br 1 goes to parent block and so on. return is essentialy sugar for br MAX)

So the strategy is to infer a blocktree from arbitrary gotos, insert blocks and translate gotos to branching in terms of levels up the tree.
"""
function blockinfo(ssa::Array)
    gotos = getgotos(ssa)
    if isempty(gotos)
        parents = [Int[] for _ = 1:length(ssa)]
    else
        parents = inferblocks(gotos)
    end
    return BlockInfo(gotos, parents)
end

isgoto(item) = isa(item, Expr) && (item.head == :(goto) || item.head == :(gotoif))
function getgotos(ssa)
    gotos = Dict{Int,Int}()
    for (i, line) in enumerate(ssa)
        !isa(line, Array) && continue
        for item in line
            if isgoto(item)
                gotos[i] = item.args[1]
            end
        end
    end
    return gotos
end

# inferblocks

function inferblocks(gotos::Dict{Int,Int})
    parents = initialblocks(gotos)
    parents = expandblocks(parents)
    parents = mergeblocks(parents, gotos)
    return parents
end

function initialblocks(gotos::Dict{Int,Int})
    # lists of which block(s) each ssa index belong to
    ssaparents = [Int[] for _ = 1:maximum(values(gotos)) + 1]
    for (origin, target) in gotos
        a, b = minmax(origin, target)
        for j = a:b
            push!(ssaparents[j], b) # named by block end index
        end
    end
    ssaparents = unique.(sort.(ssaparents, rev=true))
    return ssaparents
end

function expandblocks(ssaparents::Array{Array{Int,1},1})
    Nblocks = length(unique(vcat(ssaparents...)))
    # make sure branching (outward) can reach the intended target
    for _ = 1:Nblocks
        for (i, parents) in enumerate(ssaparents)
            length(parents) < 1 && continue
            for (level, parent) in enumerate(parents)
                length(ssaparents[parent]) < level && continue
                # a parent is named according to where it ends,
                requiredparent = ssaparents[parent][level] # so parent in this line refers to where the parent ends
                if parent != requiredparent
                    # expand required block (upward) to dominate current block
                    insert!(ssaparents[i], level, requiredparent)
                end
            end
        end
    end

    return ssaparents
end

function mergeblocks(ssaparents::Array{Array{Int,1},1}, gotos::Dict{Int,Int})
    # gotos are named according to max(origin, target) for sorting and block expanding purposes,
    # this means backward jumps (unlike forward jumps) will be named
    # according to "origin" instead of "target" and will thus produce extra blocks.
    # So conceptually; this function renames loop blocks to be named according to start
    # index and removes extra blocks produced by a "continue" jump.
    backjumps = filter(kv -> kv[2] < kv[1], gotos)
    for (i, parents) in enumerate(ssaparents)
        for (j, name) in enumerate(parents)
            if haskey(backjumps, name)
                ssaparents[i][j] = backjumps[name] # rename
            end
        end
    end
    return unique.(ssaparents) # merge
end

# translate

function goto2brlevel(bi::BlockInfo, i::Int, target::Int)
    parents = bi.parents[i]
    !(target in parents) && error("Target block not accessible: ssa index $i is not a child of target block $target")
    
    for (level, parent) in enumerate(reverse(parents))
        target == parent && return level - 1
    end
end

translate_gotos(bi::BlockInfo, i::Int, items::Array) = translate_gotos.((bi,), (i,), items)
function translate_gotos(bi::BlockInfo, i::Int, item)
    if isa(item, Expr) && item.head == :(goto)
        brlevel = goto2brlevel(bi, i, item.args[1])
        return "(br $brlevel)"
    elseif isa(item, Expr) && item.head == :(gotoif)
        brlevel = goto2brlevel(bi, i, item.args[1])
        return "br_if $brlevel"
    else
        return item
    end
end


function addblocks(bi::BlockInfo, wat::Array)
    # where and what blocks to insert into wat
    blocks = [[] for _ = 1:length(wat)]
    backtargets = values(filter(kv -> kv[2] < kv[1], bi.gotos)) # v<k means backjump (target less than origin)
    for (i, targets) in enumerate(bi.parents)
        for (level, target) in enumerate(targets)
            prevmaxlevel = length(bi.parents[i - 1])
            nextmaxlevel = length(bi.parents[i + 1])
            if prevmaxlevel < level || bi.parents[i - 1][level] != target
                target in backtargets ? push!(blocks[i], "(loop") : push!(blocks[i], "(block")
            elseif nextmaxlevel < level || bi.parents[i + 1][level] != target
                target in backtargets ? push!(blocks[i + 1], ")") : push!(blocks[i], ")") # loop end at end of line i aka first at i+1
            end
        end
    end
    
    # add them
    for (i, v) in enumerate(blocks)
        length(v) < 1 && continue
        if isnothing(wat[i])
            wat[i] = [spacedjoin(v)]
        else
            pushfirst!(wat[i], spacedjoin(v))
        end
    end
    return wat
end
