printslots(ci) = [println("_$i:  $(ci.slotnames[i])  $(ci.slottypes[i])") for i = 1:length(ci.slotnames)];
printssa(ssa) = [println("%$i:  ", itemname(ssa[i])) for i = 1:length(ssa)];
itemname(item) = isa(item, GlobalRef) ? item.name : item
itemname(item::Array) = itemname.(item)