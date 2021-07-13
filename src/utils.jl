joinn(v) = join(v, "\n\n")
parenwrap(str1::String, str2::String) = "($str1\n$str2)"

hasname(item, name) = isa(item, GlobalRef) && item.name == name || item == name
hasname(item, names::Array) = any([hasname(item, name) for name in names])
hasname(item, names::Base.KeySet) = any([hasname(item, name) for name in names])


isnothing(item) = isa(item,Nothing) || isa(item,Array) && length(item)==1 && isa(item[1], Nothing)