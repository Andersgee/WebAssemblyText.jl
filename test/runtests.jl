using Pkg; Pkg.activate("../")
using WebAssemblyText
using Test

@testset "WebAssemblyText.jl" begin
    a=1
    b=1
    @test a == b
end
