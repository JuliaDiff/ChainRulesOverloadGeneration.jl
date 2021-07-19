using ChainRulesCore
using ChainRulesOverloadGeneration

using Test

@testset "ChainRulesCore" begin
    @testset "demos" begin
        include("demos/forwarddiffzero.jl")
        include("demos/reversediffzero.jl")
    end

    # Do this after demos run, so that the simple demo code doesn't have to handle 
    # anything weird we define for testing purposes
    include("ruleset_loading.jl")
end
