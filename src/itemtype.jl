"""
    itemtype(ci::CodeInfo, item)

Get a concrete type, specialized on item type.
"""
itemtype(ci::CodeInfo, item) = typeof(item)
itemtype(ci::CodeInfo, item::DataType) = item
itemtype(ci::CodeInfo, item::Number) = typeof(item)
itemtype(ci::CodeInfo, item::SlotNumber) = ci.slottypes[item.id]
itemtype(ci::CodeInfo, item::SSAValue) = ci.ssavaluetypes[item.id]
itemtype(ci::CodeInfo, item::TypedSlot) = itemtype(ci, SlotNumber(item.id))
itemtype(ci::CodeInfo, item::Compiler.Const) = itemtype(ci, item.val)

hasitemtype(ci::CodeInfo, item, type::DataType) = itemtype(ci, item) <: type
hasitemtype(ci::CodeInfo, item, types::Array{DataType,1}) = any([itemtype(ci, item) <: type for type in types])
function hasitemtype(ci::CodeInfo, items::Array, type::DataType)
    if hasname(items[1], :(getindex)) && isa(items[2], SlotNumber)
        datatype = ci.slottypes[items[2].id]
        return datatype.parameters[1] <: type
    else
        # return any([itemtype(ci, item) <: type for item in items])
        return any([hasitemtype(ci, item, type) for item in items])
    end
end

"""
    argtypes!(ci::CodeInfo, argtypes::Dict, funcs::Dict, items::Array)

Infer argtypes and update argtypes if items[1] is in funcs.
"""
argtypes!(ci::CodeInfo, argtypes::Dict, funcs::Dict, item) = nothing
function argtypes!(ci::CodeInfo, argtypes::Dict, funcs::Dict, items::Array)
    if isa(items[1], GlobalRef) && items[1].name in keys(funcs)
        argtypes[Symbol(items[1].name)] = itemtype.((ci,), items[2:end])
    end
    argtypes!.((ci,), (argtypes,), (funcs,), items)
    return nothing
end