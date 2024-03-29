

"""
    translate(i::Integer, cinfo::CodeInfo, item)

Get a wat string from item, specialized on item type.
"""
translate(i::Integer, ci::CodeInfo, item) = item
translate(i::Integer, ci::CodeInfo, item::AbstractFloat) = "(f32.const $item)"
translate(i::Integer, ci::CodeInfo, item::Number) = "(i32.const $item)"
translate(i::Integer, ci::CodeInfo, item::Bool) = item ? "(i32.const 1)" : "(i32.const 0)"
#=
function translate(i::Integer, ci::CodeInfo, item::Number, slottype=Integer)
    if ci.ssavaluetypes[i] <: AbstractFloat
        return "(f32.const $item)"
    else
        return slottype <: Integer ? "(i32.const $item)" : "(f32.const $item)"
    end
end
translate(i::Integer, ci::CodeInfo, item::Bool, slottype=Bool) = item ? "(i32.const 1)" : "(i32.const 0)"

=#
# translate(i::Integer, ci::CodeInfo, item::Nothing) = "(i32.const 0)"

translate(i::Integer, ci::CodeInfo, item::SlotNumber) = "(local.get \$$(ci.slotnames[item.id]))"
translate(i::Integer ,ci::CodeInfo, item::GlobalRef) = "call \$$(item.name)"
translate(i::Integer ,ci::CodeInfo, item::NewvarNode) = nothing
translate(i::Integer, ci::CodeInfo, item::Const) = translate(i, ci, item.val)
translate(i::Integer, ci::CodeInfo, item::ReturnNode) = "return $(translate(i, ci, item.val))"


function translate(i::Integer, ci::CodeInfo, item::TypedSlot)
    #println("translate TypedSlot, item:",item)
    if isa(item.typ, Const)
        #println("translate TypedSlot, item.typ:",item.typ)
        return translate(i, ci, item.typ.val[1])
    else
        return item
    end
end


"""
    translate(ci::CodeInfo, items::Array)

Get a wat string from items, branching to special cases based on items[1].
"""
function translate(i::Integer, ci::CodeInfo, items::Array)
    # dont translate?
    if isnothing(items)
        return nothing
    
    # builtin to webassembly?
    elseif is_floatop_simple(ci, items)
        return ["$(floatops[items[1].name])"; translate(i, ci, items[2:end])]
    elseif is_intop_simple(ci, items)
        return ["$(intops[items[1].name])"; translate(i, ci, items[2:end])]
    
    # special expression?
    elseif hasname(items[1], :(/)) && length(items)==3
        # int/int must become floats and return float. ( float/float and div(int,int) are already taken care of with builtins)
        return ["f32.div", "(f32.convert_i32_s", translate(i, ci, items[2]), ") (f32.convert_i32_s", translate(i, ci, items[3]),")"]

    
    elseif hasname(items[1], :(size)) && length(items)==3
        return ["call \$size$(items[3])"; translate(i, ci, items[2])]
    elseif hasname(items[1], :(tuple))
        #ignore construction of tuples...
        return [translate.((i,), (ci,), items[2:end])]
    elseif hasname(items[1], :(getindex)) && length(items)==3
        if isa(items[2],SlotNumber) && istuple(ci.slottypes[items[2].id])
            #allow indexing into tuples
            id = items[2].id
            fieldnumber = items[3]
            name = fieldnumber == 1 ? "$(ci.slotnames[id])" : "$(ci.slotnames[id])$(fieldnumber)"
            return "(local.get \$$name)"
        else
            return ["call \$getlinearindex"; translate(i, ci, items[2:end])]
        end
    #=
    elseif hasname(items[1], :(vect))
        len = length(items)-1
    =#
    elseif hasname(items[1], :(setindex!)) && length(items)==4
        #if itemtype(ci, items[3]) <: Integer
        if hasitemtype(ci, items[3], [Integer, Bool])
            return ["call \$setlinearindex_int"; translate(i, ci, items[2:end])]
        else
            return ["call \$setlinearindex"; translate(i, ci, items[2:end])]
        end
    elseif hasname(items[1], :(ifelse))
        return ["select"; translate(i, ci, items[2:end])]
    elseif hasname(items[1], Symbol("return"))
        #handle both 'return' and 'return nothing' (and simply 'nothing' at end of function) as simply return
        if hasname(items[2], Symbol("nothing")) || isnothing(items[2])
            return ["return"]
        elseif isa(items[2], Array) && hasname(items[2][1], :(tuple))
            return ["return"; translate(i, ci, items[2][2:end])]
        else 
            return ["return"; translate(i, ci, items[2:end])]
        end
    elseif hasname(items[1], :(not_int))
        return ["i32.eqz", translate(i, ci, items[2])]
    elseif hasname(items[1], Symbol("==="))
        if typeof(items[3]) <: Nothing
            if isa(items[2], SlotNumber) && string(ci.slotnames[items[2].id])[1] == '_' # iterator variable begins with "_"
                return ["i32.eqz", "(local.get \$$(ci.slotnames[items[2].id])i)"] # the iteratorindex
            elseif itemtype(ci, items[2]) <: AbstractFloat
                return ["f32.eq", translate(i, ci, items[2]), "(f32.const 0.0)"]
            else
                return ["i32.eqz", translate(i, ci, items[2])]
            end
        else
            return ["i32.eq"; translate(i, ci, items[2:3])]
        end
    # elseif hasname(items[1], :(=))
    #    slotname = ci.slotnames[items[2].id]
    #    return ["local.set \$$(slotname)", translate(i, ci, items[3])]
    
    elseif hasname(items[1], :(=))
        slotname = ci.slotnames[items[2].id]
        slottype = ci.slottypes[items[2].id]
        if isa(items[3], Array) && is_iterate(items[3][1])
            return ["local.set \$$(slotname) ( local.set \$$(slotname)i", translate(i, ci, items[3]), ")"]
        elseif isa(items[3], Array) && istuple(slottype)
            settuples = []
            closetuples = []
            for n = 2:length(slottype.parameters)
                push!(settuples,"(local.set \$$(slotname)$(n)")
                push!(closetuples, ")")
            end
            settuples = spacedjoin(settuples)
            closetuples = spacedjoin(closetuples)
            return ["local.set \$$(slotname)",settuples, translate(i, ci, items[3]), closetuples]
        else
            #here maybe check for the type of the slotname, if its float then use f32 inside translate?
            #if (typeof(items[3]) <: Number)
            #    return ["local.set \$$(slotname)", translate(i, ci, items[3], slottype)]
            #else 
                return ["local.set \$$(slotname)", translate(i, ci, items[3])]
            #end
        end
    elseif hasname(items[1], :(println))
        if itemtype(ci, items[2]) <: String
            w1,w2 = inlined_tmparray(items[2])
            return [string(w1, w2, "(call \$console_log (i32.const 4))")] #concat strings
        else
            return ["(call \$console_log", translate(i, ci, items[2]), ")"]
        end
    elseif hasname(items[1], :(error))
        if itemtype(ci, items[2]) <: String
            w1,w2 = inlined_tmparray(items[2])
            return [string(w1, w2, "(call \$console_error (i32.const 4))\n(unreachable)")] #concat strings
        else
            return ["(call \$console_error", translate(i, ci, items[2]), ")\n(unreachable)"]
        end

    # default individual translation
    else
        return translate.((i,), (ci,), items)
    end
end

function inlined_tmparray(str::String)
    #also write "unreachable" if throw() and maybe even abort function ("return" in wasm) if error() is called. 
    #in julia, error is supposed to abort ececution in parent function aswell?

    v = [Int32(c) for c in str] #convert ASCII/Unicode chars to i32
    watstring1 = "(call \$setsize_tmp (i32.const $(length(v))) (i32.const 1))\n"
    watstring2 = join(["(call \$setlinearindex_int_tmp (i32.const $x) (i32.const $i)) ;;$(Char(x))\n" for (i, x) in enumerate(v)], "")

    return watstring1, watstring2
end

is_iterate(item) = isa(item, GlobalRef) && length(string(item.name)) >= 7 && string(item.name)[1:7] == "iterate"
is_floatop_simple(ci::CodeInfo, items) = isa(items[1], GlobalRef) && items[1].name in keys(floatops) && (hasitemtype(ci, items[2], AbstractFloat) || (length(items) > 2 && hasitemtype(ci, items[3], AbstractFloat)))
is_intop_simple(ci::CodeInfo, items) = isa(items[1], GlobalRef) && items[1].name in keys(intops) && (hasitemtype(ci, items[2], [Integer, Bool, Nothing]) || (length(items) > 2 && hasitemtype(ci, items[3], [Integer, Bool, Nothing])))

floatops = Dict(
:(+) => "f32.add", # these consume 2 args 
:(-) => "f32.sub",
:(*) => "f32.mul",
:(/) => "f32.div",
:(==) => "f32.eq",
:(!=) => "f32.ne",
:(<) => "f32.lt",
:(>) => "f32.gt",
:(<=) => "f32.le",
:(>=) => "f32.ge",
:(min) => "f32.min",
:(max) => "f32.max",
:(copysign) => "f32.copysign",
:(abs) => "f32.abs", # these consume 1 arg
:(ceil) => "f32.ceil",
:(floor) => "f32.floor",
:(trunc) => "f32.trunc",
:(round) => "f32.nearest",
:(sqrt) => "f32.sqrt",
:(float) => "f32.convert_i32_s",
:(Int) => "i32.trunc_f32_s",
# :(^) => ["call \$pow",2],
# ""=>["f32.neg",1],
# ""=>["f32.load",1],
# ""=>["f32.store",2],
# ""=>["f32.const",1],
)

intops = Dict(
:(+) => "i32.add", # these consume 2 args 
:(-) => "i32.sub",
:(*) => "i32.mul",
:(div) => "i32.div_s", # julia 4/2 will return float. but div(4,2) wont
# :(/) => "i32.div_s", # julia 4/2 will return float. but div(4,2) wont
:(%) => "i32.rem_s",
:(mod) => "i32.rem_s",
:(rem) => "i32.rem_s",
:(&&) => "i32.and",
:(||) => "i32.or",
:(⊻) => "i32.xor",
:(xor) => "i32.xor",
:(<<) => "i32.shl",
:(>>) => "i32.shr_s",
:(==) => "i32.eq",
# :(===) => "i32.eq", #handle this in a special way.
:(!=) => "i32.ne",
:(<) => "i32.lt_s",
:(>) => "i32.gt_s",
:(<=) => "i32.le_s",
:(>=) => "i32.ge_s",
:(!) => "i32.eqz", # these consume 1 arg
:(not_int) => "i32.eqz",
:(leading_zeros) => "i32.clz",
:(trailing_zeros) => "i32.ctz",
:(count_ones) => "i32.popcnt",
:(float) => "f32.convert_i32_s",
:(Int) => "i32.trunc_f32_s",
# :(^) => ["call \$powi",2],
# ""=>["i32.load",1]
# ""=>["i32.store",2]
# ""=>["i32.const",1]
)