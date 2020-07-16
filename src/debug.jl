printslots(ci) = [println("_$i:  $(ci.slotnames[i])  $(ci.slottypes[i])") for i = 1:length(ci.slotnames)];
printssa(ssa) = [println("%$i:  ", itemname(ssa[i])) for i = 1:length(ssa)];
printssatypes(ssa,ci) = [println("$(ci.ssavaluetypes[i])\t%$i:  ", itemname(ssa[i])) for i = 1:length(ci.ssavaluetypes)];
# printssatypes(ci) = [println("%$i:  $(ci.ssavaluetypes[i])") for i = 1:length(ci.ssavaluetypes)];
itemname(item) = isa(item, GlobalRef) ? item.name : item
itemname(item::Array) = itemname.(item)

function debugprint(ssa, ci)
    println("\nDebug info:")
    printssatypes(ssa, ci)
    printslots(ci)
    println()
end