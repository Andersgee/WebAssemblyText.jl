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
    return join([decl; ret; locals], " ")
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
translate(i::Integer, ci::CodeInfo, item::TypedSlot) = "(local.get \$$(ci.slotnames[item.id]))"
translate(i::Integer ,ci::CodeInfo, item::GlobalRef) = "call \$$(item.name)"

"""
    translate(ci::CodeInfo, items::Array)

Get a wat string from items, branching to special cases based on items[1].
"""
function translate(i::Integer, ci::CodeInfo, items::Array)
    # builtin to webassembly?
    if is_floatop(ci, items)
        return ["$(floatops[items[1].name][1])"; translate(i, ci, items[2:end])]
    elseif is_intop(ci, items)
        return ["$(intops[items[1].name][1])"; translate(i, ci, items[2:end])]
    
    # special expression?
    elseif hasname(items[1], :(ifelse))
        return ["select"; translate(i, ci, items[2:end])]
    elseif hasname(items[1], Symbol("return")) && hasname(items[2], Symbol("nothing"))
        return ["return"]
    elseif hasname(items[1], :(===)) && typeof(items[3]) <: Nothing
        if itemtype(ci, items[2]) <: AbstractFloat
            return ["f32.eq", translate(i, ci, items[2]), "(f32.const 0.0)"]
        else
            return ["i32.eqz", translate(i, ci, items[2])]
        end
    elseif hasname(items[1], :(:))
        return nothing # dont translate iterator declaration (but use it in restructure)
    elseif hasname(items[1], :(=))
        return ["local.set \$$(ci.slotnames[items[2].id])", translate(i, ci, items[3])]
    elseif hasname(items[1], :(gotoifnot))
       # [gotoifnot,cond,target] => [br_if Nlevels, not(cond)]
        target = items[3]
        if target < i
            return ["br_if 0", ["i32.eqz"; translate(i, ci, items[2])]] # continue
        else
            return ["br_if 1", ["i32.eqz"; translate(i, ci, items[2])]] # break
        end

    # default
    else
        return translate.((i,), (ci,), items)
    end
end

is_intop(ci::CodeInfo,items) = isa(items[1], GlobalRef) && (itemtype(ci, items[2]) <: Integer || itemtype(ci, items[2]) <: Bool || itemtype(ci, items[2]) <: Nothing) && items[1].name in keys(intops)
is_floatop(ci::CodeInfo,items) = isa(items[1], GlobalRef) && itemtype(ci, items[2]) <: AbstractFloat && items[1].name in keys(floatops)

floatops = Dict(
:(+) => ["f32.add",2],
:(-) => ["f32.sub",2],
:(*) => ["f32.mul",2],
:(/) => ["f32.div",2],
:(==) => ["f32.eq",2],
:(!=) => ["f32.ne",2],
:(<) => ["f32.lt",2],
:(>) => ["f32.gt",2],
:(<=) => ["f32.le",2],
:(>=) => ["f32.ge",2],
:(min) => ["f32.min",2],
:(max) => ["f32.max",2],
:(copysign) => ["f32.copysign",2],
:(abs) => ["f32.abs",1],
:(ceil) => ["f32.ceil",1],
:(floor) => ["f32.floor",1],
:(trunc) => ["f32.trunc",1],
:(round) => ["f32.nearest",1],
:(sqrt) => ["f32.sqrt",1],
:(float) => ["f32.convert_i32_s",1],
:(Int) => ["i32.trunc_f32_s",1],
#:(^) => ["call \$pow",2],
# ""=>["f32.neg",1],
# ""=>["f32.load",1],
# ""=>["f32.store",2],
# ""=>["f32.const",1],
)

intops = Dict(
:(+) => ["i32.add",2],
:(-) => ["i32.sub",2],
:(*) => ["i32.mul",2],
:(div) => ["i32.div_s",2], # julia 4/2 will return float. but div(4,2) wont
:(%) => ["i32.rem_s",2],
:(%) => ["i32.rem_s",2],
:(rem) => ["i32.rem_s",2],
:(&&) => ["i32.and",2],
:(||) => ["i32.or",2],
:(⊻) => ["i32.xor",2],
:(xor) => ["i32.xor",2],
:(<<) => ["i32.shl",2],
:(>>) => ["i32.shr_s",2],
:(==) => ["i32.eq",2],
:(!=) => ["i32.ne",2],
:(<) => ["i32.lt_s",2],
:(>) => ["i32.gt_s",2],
:(<=) => ["i32.le_s",2],
:(>=) => ["i32.ge_s",2],
:(!) => ["i32.eqz",1],
:(not_int) => ["i32.eqz",1],
:(leading_zeros) => ["i32.clz",1],
:(trailing_zeros) => ["i32.ctz",1],
:(count_ones) => ["i32.popcnt",1],
:(float) => ["f32.convert_i32_s",1],
:(Int) => ["i32.trunc_f32_s",1],
#:(^) => ["call \$powi",2],
# ""=>["i32.load",1]
# ""=>["i32.store",2]
# ""=>["i32.const",1]
)