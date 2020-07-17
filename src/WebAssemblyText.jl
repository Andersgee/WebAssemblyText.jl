module WebAssemblyText

using Core: Compiler, SSAValue, SlotNumber, TypedSlot, GotoNode, CodeInfo
using Core.Compiler: GotoIfNot
# Evalscope is a dummy module where all evaluated expressions live.
module Evalscope end

include("structure.jl")
include("itemtype.jl")
include("utils.jl")
include("translate.jl")
include("controlflow.jl")
include("stringify.jl")
include("builtins.jl")
include("imports.jl")
include("debug.jl")
include("parse.jl")
include("jl2wat.jl")

export jl2wat, jlstring2wat

end
