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