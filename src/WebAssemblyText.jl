module WebAssemblyText

using Core: Compiler, SSAValue, SlotNumber, TypedSlot, GotoNode, CodeInfo, NewvarNode
using Core.Compiler: GotoIfNot, PartialStruct
using Core: ReturnNode

"""
Evalscope is a dummy module where all evaluated expressions live.
"""
module Evalscope end

mutable struct BlockInfo
    gotos::Dict{Int,Int}
    parents::Array{Array{Int,1},1}
end

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

export jl2wat, jlstring2wat, @code_wat

end
