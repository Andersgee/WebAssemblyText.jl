function debugprint(ssa, cinfo, binfo)
    display(cinfo)
    debugprintssa(ssa, cinfo)
    debugprintblockinfo(binfo)
end
printslots(ci) = [println("_$i:  $(ci.slotnames[i])  $(ci.slottypes[i])") for i = 1:length(ci.slotnames)];
printssa(ssa) = [println("%$i:  ", itemname(ssa[i])) for i = 1:length(ssa)];
printssatypes(ssa,ci) = [println("$(ci.ssavaluetypes[i])\t%$i:  ", itemname(ssa[i])) for i = 1:length(ci.ssavaluetypes)];
# printssatypes(ci) = [println("%$i:  $(ci.ssavaluetypes[i])") for i = 1:length(ci.ssavaluetypes)];
itemname(item) = isa(item, GlobalRef) ? item.name : item
itemname(item::Array) = itemname.(item)

function debugprintssa(ssa, ci)
    println("\nSlots:")
    printslots(ci)
    println("\nSSA:")
    printssatypes(ssa, ci)
    println()
end

function debugprintblockinfo(binfo)
    println("Inferred blocktree (parents of each ssa index):")
    for (i, v) in enumerate(binfo.parents)
        if length(v) > 0
            println(i, ": ", v)
        else
            println(i, ": ")
        end
    end
    println()
end