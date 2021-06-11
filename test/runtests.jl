using ChainRulesCore
using ChainRulesOverloadGeneration

using Test

@testset "ChainRulesCore" begin
    include("ruleset_loading.jl")

    @testset "demos" begin
        include("demos/forwarddiffzero.jl")
        include("demos/reversediffzero.jl")
    end
end
