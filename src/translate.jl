"""
    declaration(cinfo, func, argtypes, Rtype)

Get a wat string with function declaration.
"""
function declaration(cinfo, func, argtypes, Rtype)
    Nparams = length(argtypes)
    slotnames = cinfo.slotnames[2:end]
    slottypes = cinfo.slottypes[2:end]
    slottypes = [slottype <: AbstractFloat ? "f32" : "i32" for slottype in slottypes]

    decl = ["func \$$func (export \"$func\")"]
    locals = []
    for i = 1:length(slotnames)
        if i <= Nparams
            push!(decl, "(param \$$(slotnames[i]) $(slottypes[i]))")
        else
            push!(locals, "(local \$$(slotnames[i]) $(slottypes[i]))")
        end
    end
    ret = ""
    if !(Rtype <: Nothing)
        rt = Rtype <: AbstractFloat ? "f32" : "i32"
        ret = "(result $rt)"
    end
    return join([decl; ret; "\n"; locals], " ")
end


"""
    translate(i::Integer, cinfo::CodeInfo, item)

Get a wat string from item, specialized on item type.
"""
translate(i::Integer, ci::CodeInfo, item) = item
translate(i::Integer, ci::CodeInfo, item::AbstractFloat) = "(f32.const $item)"
translate(i::Integer, ci::CodeInfo, item::Number) = "(i32.const $item)"
translate(i::Integer, ci::CodeInfo, item::Nothing) = "(i32.const 0)"
translate(i::Integer, ci::CodeInfo, item::Bool) = item ? "(i32.const 1)" : "(i32.const 0)"
translate(i::Integer, ci::CodeInfo, item::SlotNumber) = "(local.get \$$(ci.slotnames[item.id]))"
# translate(i::Integer, ci::CodeInfo, item::TypedSlot) = "(local.get \$$(ci.slotnames[item.id]))"
translate(i::Integer ,ci::CodeInfo, item::GlobalRef) = "call \$$(item.name)"
translate(i::Integer ,ci::CodeInfo, item::NewvarNode) = nothing

"""
    translate(ci::CodeInfo, items::Array)

Get a wat string from items, branching to special cases based on items[1].
"""
function translate(i::Integer, ci::CodeInfo, items::Array)
    # dont translate?
    if isnothing(items)
        return nothing
    
    # builtin to webassembly?
    elseif is_floatop(ci, items)
        return ["$(floatops[items[1].name])"; translate(i, ci, items[2:end])]
    elseif is_intop(ci, items)
        return ["$(intops[items[1].name])"; translate(i, ci, items[2:end])]
    
    # special expression?
    elseif hasname(items[1], :(ifelse))
        return ["select"; translate(i, ci, items[2:end])]
    elseif hasname(items[1], Symbol("return")) && hasname(items[2], Symbol("nothing"))
        return ["return"]
    elseif hasname(items[1], :(not_int))
        return ["i32.eqz", translate(i, ci, items[2])]
    elseif hasname(items[1], Symbol("==="))
        if typeof(items[3]) <: Nothing
            if itemtype(ci, items[2]) <: AbstractFloat
                return ["f32.eq", translate(i, ci, items[2]), "(f32.const 0.0)"]
            elseif isa(items[2],SlotNumber) #should prob check if items[2].id is a iteratorvariable
                return ["i32.eqz", "(local.get \$$(ci.slotnames[items[2].id])bool)"] #the iterator bool
            else
                return ["i32.eqz", translate(i, ci, items[2])]
            end
        else
            #I think === is only used comparing with nothing so this else might never happen
            return ["i32.eq", translate(i, ci, items[2:end])]
        end
    elseif hasname(items[1], :(=))
        slotname = ci.slotnames[items[2].id]
        if isa(items[3],Array) && hasname(items[3][1], Symbol("iteratorbool"))
            return ["local.set \$$(slotname) (local.set \$$(slotname)bool (i32.const 1))", translate(i, ci, items[3][2])]
        else
            if isa(items[3],Array) && hasname(items[3][1], :(iterate))
                #builtin iterate returns a tuple so consume both
                return ["local.set \$$(slotname) ( local.set \$$(slotname)bool ", translate(i, ci, items[3]), ")"]
            else
                return ["local.set \$$(slotname)", translate(i, ci, items[3])]
            end
        end

    # default individual translation
    else
        return translate.((i,), (ci,), items)
    end
end

is_floatop(ci::CodeInfo,items) = isa(items[1], GlobalRef) && items[1].name in keys(floatops) && (hasitemtype(ci, items[2], AbstractFloat) || (length(items) > 2 && hasitemtype(ci, items[3], AbstractFloat)))
is_intop(ci::CodeInfo,items) = isa(items[1], GlobalRef) && items[1].name in keys(intops) && (hasitemtype(ci, items[2], [Integer, Bool, Nothing]) || (length(items) > 2 && hasitemtype(ci, items[3], [Integer, Bool, Nothing])))

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
:(%) => "i32.rem_s",
:(%) => "i32.rem_s",
:(rem) => "i32.rem_s",
:(&&) => "i32.and",
:(||) => "i32.or",
:(⊻) => "i32.xor",
:(xor) => "i32.xor",
:(<<) => "i32.shl",
:(>>) => "i32.shr_s",
:(==) => "i32.eq",
#:(===) => "i32.eq", #handle this in a special way.
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