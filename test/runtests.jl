using ChainRulesCore
using ChainRulesOverloadGeneration
# resolve conflicts while this code exists in both.
const on_new_rule = ChainRulesOverloadGeneration.on_new_rule
const refresh_rules = ChainRulesOverloadGeneration.refresh_rules

using Test

@testset "ChainRulesCore" begin
    include("ruleset_loading.jl")

    @testset "demos" begin
        include("demos/forwarddiffzero.jl")
        include("demos/reversediffzero.jl")
    end
end
