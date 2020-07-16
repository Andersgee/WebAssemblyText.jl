"""
    structure(item::Expr)

Expression as a vector: [head, args...]

# Detals:
There are two expression flavors:
- head in args[1]
- head in head

make them be represented the same way

- eval refs of constants
"""
structure(item) = item
structure(items::Array) = structure.(items)
structure(item::TypedSlot) = SlotNumber(item.id)

function structure(item::GlobalRef)
    evaluatedref = Base.eval(Evalscope,item)
    #evaulate refs to constants, also turn π, ℯ, γ, φ and catalan to float rather than irrational
    if typeof(evaluatedref) <: Number
        if typeof(evaluatedref) <: AbstractFloat || typeof(evaluatedref) <: Irrational
            return AbstractFloat(evaluatedref)
        else
            return evaluatedref
        end
    else
        return item
    end
end

function structure(item::Expr)
    if item.head == :(call)
        head = item.args[1]
        args = item.args[2:end]
    else
        head = item.head
        args = item.args
    end
    return [head; structure(args)]
end

"""
    restructure(items)

Restructure items for more straightforward translation.

# Details:
- expand Nary representation ([mul,a,b,c,d] => [mul,d,[mul,c,[mul,a,b]]])
- insert implied iterator increment ([:,1,4] => [:,1,1,4])
- pick only initial iterator value if :(iterate) has a single arg [:(iterate),target] => ssa[target][1]
- specify :(iteratef) instead of :(iterate) for float iteration.
- move ifelse condition to last arg, corresponding to .wat select [ifselse, cond, a, b] => [ifselse, a, b, cond]

# TODO:
- expand chains of comparisons [comparison, 1, <, i, <=, n] => [&&,[<,1,i],[<=,i,n]]
- .wat dont have Bool or Nothing types so iterating across zero does NOT work.. figure out a way to solve this
"""
restructure(i::Integer, ssa::Array, item) = item
function restructure(i::Integer, ssa::Array, items::Array)
    if length(items) > 3 && hasname(items[1], keys(floatops))
        # expand Nary
        expanded = items[1:3]
        for i = 4:length(items)
            expanded = [items[1], items[i], expanded]
        end
        return expanded
    elseif hasname(items[1], :(getfield))
        return items[2] # the SlotNumber of the TypedSlot
    elseif hasname(items[1], :(ifelse))
        return [items[1],items[3],items[4],items[2]]
    elseif hasname(items[1], :(iterate))
        target = items[2].id
        iteratorargs = ssa[target][2:end]
        head = typeof(iteratorargs[1]) <: AbstractFloat ? GlobalRef(Evalscope, :(iteratef)) : GlobalRef(Evalscope, :(iterate))
        if length(items) == 2
            return iteratorargs[1]
        else
            if length(iteratorargs) == 2
                return [head; iteratorargs[1]; 1; iteratorargs[2]; items[3]] # a,b => a,1,b
            else
                return [head; iteratorargs; items[3]]
            end
        end
    else
        return restructure.((i,), (ssa,), items)
    end
end


