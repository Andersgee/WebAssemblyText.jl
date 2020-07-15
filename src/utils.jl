joinn(v) = join(v, "\n\n")
parenwrap(str1::String, str2::String) = "($str1\n$str2)"

hasname(item, name) = isa(item, GlobalRef) && item.name == name || item == name
hasanyname(item, names) = any([hasname(item, name) for name in names])
