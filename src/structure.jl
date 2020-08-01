"""
    structure(item::Expr)

Format expression as a vector: [operator, operands...]

Another name could be listify

# Details:
- Expressions dont always have the operator in head, sometimes its in args[1] and head is just :call
- pi et al are refs, so if eval(item) is a number just use the number instead of the ref
"""
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

structure(item) = item
structure(items::Array) = structure.(items)
structure(item::TypedSlot) = SlotNumber(item.id)

function structure(item::GlobalRef)
    evaluatedref = Base.eval(Evalscope, item)
    # evaulate refs to constants into constants, also turn π, ℯ, γ, φ and catalan to float rather than irrational
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

"""
    restructure(items)

Restructure items for more straightforward translation.

# Details:
- expand N-ary representation ([mul,a,b,c,d] => [mul,d,[mul,c,[mul,a,b]]])
- iterate: pick initial value if single arg
- iterate: insert implied increment ([:,1,4] => [:,1,1,4])
- rewrite ifelse as select [ifselse, cond, a, b] => [select, a, b, cond]
"""
restructure(i::Integer, ssa::Array, item) = item
restructure(i::Integer, ssa::Array, item::GotoNode) = Any[Expr(:(goto), item.label)]
function restructure(i::Integer, ssa::Array, items::Array)
    if length(items) > 3 && hasname(items[1], keys(floatops))
        # expand N-ary
        expanded = items[1:3]
        for i = 4:length(items)
            expanded = [items[1], items[i], expanded]
        end
        return expanded
    
    elseif hasname(items[1], :(getfield))
        ssaindex = items[2].id
        fieldnumber = items[3]
        # getfield will refer to an iterator tuple
        # items[2] is a ssa ref, items[3] is fieldnumber
        # with 1 meaning "get value"
        # and 2 meaning "increment index"
        # return ssa[items[2].id][fieldnumber]
        
        if items[3] == 1
            return items[2]
        else
            id = ssa[items[2].id].id
            name = "_$(id)"
            return "(local.get \$$name)"
        end
      
    elseif hasname(items[1], :(ifelse))
        return [items[1],items[3],items[4],items[2]]
    elseif hasname(items[1], :(:))
        return nothing
    elseif hasname(items[1], :(iterate))
        target = items[2].id
        iteratorargs = ssa[target][2:end]
        head = GlobalRef(Evalscope, :(iterate))
        if length(items) == 2
            return [Symbol("iteratorbool"), iteratorargs[1]]
        else
            if length(iteratorargs) == 2
                return [head; iteratorargs[1]; 1; iteratorargs[2]; items[3]] # a,b => a,1,b
            else
                return [head; iteratorargs; items[3]]
            end

        end
    elseif hasname(items[1], :(gotoifnot))
        target = items[3]
        return [Expr(:(gotoif), target), ["i32.eqz"; items[2]]]
    else
        return restructure.((i,), (ssa,), items)
    end
end


