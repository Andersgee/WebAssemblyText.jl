"""
    structure(items)

Recursively format expressions as lists: [operator, operands...]

# Notes:
list trees (aka S-expressions) are convenient to work with because modifying it with a recursive function is easy.
Also, WebAssembly supports text format written in S-expressions so if all required functionality like
overloading, phinodes and such was built into WebAssembly one could essentially do a one liner:
webassemblytext = translate(structure(code_typed(somejuliafunction))

# Details:
- Expressions dont always have the operator in head, sometimes its in args[1] and head is just :call
- pi et al are refs, so if eval(item) is a number just use the number instead of the ref
"""
structure(items::Array) = structure.(items)
structure(item) = item
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

function structure(item::GlobalRef)
    evaluatedref = Base.eval(Evalscope, item)
    # evaulate refs to constants into constants, also turn π, ℯ et al. to float rather than irrational
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
- rewrite ifelse as select [ifselse, cond, a, b] => [select, a, b, cond]
"""
restructure(ci::CodeInfo, i::Integer, ssa::Array, item) = item
restructure(ci::CodeInfo, i::Integer, ssa::Array, item::GotoNode) = Any[Expr(:(goto), item.label)]
function restructure(ci::CodeInfo, i::Integer, ssa::Array, items::Array)
    if length(items) > 3 && hasname(items[1], keys(floatops))
        # expand N-ary
        expanded = items[1:3]
        for i = 4:length(items)
            expanded = [items[1], items[i], expanded]
        end
        return expanded
    
    elseif hasname(items[1], :(getfield))
        fieldnumber = items[3]
        if isa(items[2], SlotNumber)
            id = items[2].id
            name = fieldnumber == 1 ? "_$(ci.slotnames[id])" : "_$(ci.slotnames[id])$(fieldnumber)" # get value or index
            return "(local.get \$$name)"
        elseif isa(items[2], SSAValue)
            if isa(ssa[items[2].id], Array)
                # getfield refers to some expression, Julia seems to handle this by a some macro that.. does something
                error("getfield with expression as target, unsure what to return. If tuple assigment like a,b = myfunc(). Solve by doing ab = myfunc() followed by getfield(ab,1) or getfield(ab,2) when needed. getfield is completely cost free.")
                return ssa[items[2].id][2]
            else
                # getfield refers to an iterator tuple
                target = items[2].id
                id = ssa[target].id
                name = fieldnumber == 1 ? "_$(id)" : "_$(id)i" # get value or index
                # maybe return nothing if fieldnumber == 2.. this makes for x in v work...
                # because the reference that will use up this line is replaced in specializediterate
                # fieldnumber == 2 && return nothing
                return "(local.get \$$name)"
            end
        else
            return "unknown_getfield_on_$(items[2])"
        end
        
    elseif hasname(items[1], :(iterate))
        return specializediterate(ci, i, ssa, items)
    elseif hasname(items[1], :(ifelse))
        return [items[1],items[3],items[4],items[2]]
    elseif hasname(items[1], :(:))
        # return items[2:end]
        return nothing
    elseif hasname(items[1], :(gotoifnot))
        target = items[3]
        return [Expr(:(gotoif), target), ["i32.eqz"; items[2]]]
    else
        return restructure.((ci,), (i,), (ssa,), items)
    end
end


function specializediterate(ci, i, ssa, items)
    # single arg => initial value, initial index
    # two args => next value, next index
    ssaref = items[2]
    target = items[2].id
    iterator = ssa[target]
    iteratortype = ci.ssavaluetypes[target]
    if iteratortype <: Array
        if length(items) == 2
            return [GlobalRef(Evalscope, :(iteratearray_init)); ssaref]
        else
            # return [GlobalRef(Evalscope, :(iteratearray)); ssaref; items[3]]
            id = ssa[ssa[items[3].id][2].id].id
            iteratorindex = "(local.get \$_$(id)i)"
            return [GlobalRef(Evalscope, :(iteratearray)); ssaref; iteratorindex]
        end
    # for range functions, pass iteratorvalue instead of iteratorindex as iteratorindex
    elseif iteratortype <: UnitRange
        if length(items) == 2
            return [GlobalRef(Evalscope, :(iterateunitrange_init)); iterator[2:end]]
        else
            # return [GlobalRef(Evalscope, :(iterateunitrange)); iterator[2:end]; items[3]]
            # println("UnitRange, ssa[items[3].id]: ", ssa[items[3].id])
            id = ssa[ssa[items[3].id][2].id].id # walk along some refs to find which slotname it is
            iteratorval = "(local.get \$_$(id))"
            # ssa[items[3].id] = nothing
            return [GlobalRef(Evalscope, :(iterateunitrange)); iterator[2:end]; iteratorval]
        end
    elseif iteratortype <: StepRange
        if length(items) == 2
            return [GlobalRef(Evalscope, :(iteratesteprange_init)); iterator[2:end]]
        else
            # return [GlobalRef(Evalscope, :(iteratesteprange)); iterator[2:end]; items[3]]
            id = ssa[ssa[items[3].id][2].id].id
            iteratorval = "(local.get \$_$(id))"
            return [GlobalRef(Evalscope, :(iteratesteprange)); iterator[2:end]; iteratorval]
        end
    elseif iteratortype <: StepRangeLen
        if length(items) == 2
            return [GlobalRef(Evalscope, :(iteratesteprangelen_init)); iterator[2:end]]
        else
            id = ssa[ssa[items[3].id][2].id].id
            iteratorval = "(local.get \$_$(id))"
            return [GlobalRef(Evalscope, :(iteratesteprangelen)); iterator[2:end]; iteratorval]
        end
    else
        if length(items) == 2
            return [GlobalRef(Evalscope, :(iteratecollection_init)); ssaref]
        else
            return [GlobalRef(Evalscope, :(iteratecollection)); ssaref; items[3]]
        end
    end
end