@testset "ruleset_loading.jl" begin
    @testset "on_new_rule" begin
        frule_history = []
        rrule_history = []
        on_new_rule(frule) do sig
            op = sig.parameters[1]
            push!(frule_history, op)
        end
        on_new_rule(rrule) do sig
            op = sig.parameters[1]
            push!(rrule_history, op)
        end

        @testset "new rules hit the hooks" begin
            # Now define some rules
            @scalar_rule x + y (1, 1)
            @scalar_rule x - y (1, -1)
            refresh_rules()

            @test Set(frule_history[end-1:end]) == Set((typeof(+), typeof(-)))
            @test Set(rrule_history[end-1:end]) == Set((typeof(+), typeof(-)))
        end

        @testset "# Make sure nothing happens anymore once we clear the hooks" begin
            ChainRulesOverloadGeneration.clear_new_rule_hooks!(frule)
            ChainRulesOverloadGeneration.clear_new_rule_hooks!(rrule)

            old_frule_history = copy(frule_history)
            old_rrule_history = copy(rrule_history)

            @scalar_rule sin(x) cos(x)
            refresh_rules()

            @test old_rrule_history == rrule_history
            @test old_frule_history == frule_history
        end
    end


    @testset "_primal_sig" begin
        _primal_sig = ChainRulesOverloadGeneration._primal_sig
        @testset "frule" begin
            @test isequal(  # DataType without shared type but with constraint
                _primal_sig(frule, Tuple{typeof(frule), Any, typeof(*), Int, Vector{Int}}),
                Tuple{typeof(*), Int, Vector{Int}}
            )
            @test isequal(  # UnionAall without shared type but with constraint
                _primal_sig(frule, Tuple{typeof(frule), Any, typeof(*),  T, Int} where T<:Real),
                Tuple{typeof(*), T, Int} where T<:Real
            )
            @test isequal(  # UnionAall with share type
                _primal_sig(frule, Tuple{typeof(frule), Any, typeof(*), T, Vector{T}} where T),
                Tuple{typeof(*), T, Vector{T}} where T
            )
        end

        @testset "rrule" begin
            @test isequal(  # DataType without shared type but with constraint
                _primal_sig(rrule, Tuple{typeof(rrule), typeof(*), Int, Vector{Int}}),
                Tuple{typeof(*), Int, Vector{Int}}
            )
            @test isequal(  # UnionAall without shared type but with constraint
                _primal_sig(rrule, Tuple{typeof(rrule), typeof(*),  T, Int} where T<:Real),
                Tuple{typeof(*), T, Int} where T<:Real
            )
            @test isequal(  # UnionAall with share type
                _primal_sig(rrule, Tuple{typeof(rrule), typeof(*), T, Vector{T}} where T),
                Tuple{typeof(*), T, Vector{T}} where T
            )
        end
    end

    @testset "_rule_list" begin
        _rule_list = ChainRulesOverloadGeneration._rule_list
        @testset "should not have frules that need RuleConfig" begin
            old_frule_list = collect(_rule_list(frule))
            function ChainRulesCore.frule(
                ::RuleConfig{>:Union{HasForwardsMode,HasReverseMode}}, dargs, sum, f, xs
            )
                return 1.0, 1.0 # this will not be call so return doesn't matter
            end
            # New rule should not have appeared
            @test collect(_rule_list(frule)) == old_frule_list
        end

        @testset "should not have rrules that need RuleConfig" begin
            @testset "normal type sigs" begin
                old_rrule_list = collect(_rule_list(rrule))
                function ChainRulesCore.rrule(
                    ::RuleConfig{>:Union{HasForwardsMode,HasReverseMode}}, sum, f, xs
                )
                    return 1.0, x->(x,x,x) # this will not be call so return doesn't matter
                end
                # New rule should not have appeared
                @test collect(_rule_list(rrule)) == old_rrule_list
            end
            @testset "UnionAll type sigs" begin
                old_rrule_list = collect(_rule_list(rrule))
                function ChainRulesCore.rrule(
                    ::RuleConfig{>:Union{HasForwardsMode,HasReverseMode}}, sum, f::F, xs
                ) where F <: Function
                    return 1.0, x->(x,x,x) # this will not be call so return doesn't matter
                end
                # New rule should not have appeared
                @test collect(_rule_list(rrule)) == old_rrule_list
                # Above would error if we were not handling UnionAll's right
            end
        end


        @testset "opting out" begin
            oa_id(x, y) = x
            @scalar_rule(oa_id(x::Number), 1)
            @opt_out ChainRulesCore.rrule(::typeof(oa_id), x::Float32)
            @opt_out ChainRulesCore.frule(::Any, ::typeof(oa_id), x::Float32)

            # In theses tests we `@assert` the behavour that `methods` has
            # and then `@test` that `_rule_list` differs from that, in the way we want
            
            @test !isempty([m for m in _rule_list(rrule) if m.sig <: Tuple{Any,typeof(oa_id),Number}])
            # Opted out
            @assert !isempty([m for m in methods(rrule) if m.sig <: Tuple{Any,typeof(oa_id),Float32}])
            @test isempty([m for m in _rule_list(rrule) if m.sig <: Tuple{Any,typeof(oa_id),Float32}])
            # fallback
            @test !isempty([m for m in methods(rrule) if m.sig == Tuple{typeof(rrule),Any,Vararg{Any}}])
            @test isempty([m for m in _rule_list(rrule) if m.sig == Tuple{typeof(rrule),Any,Vararg{Any}}])

            @test !isempty([m for m in _rule_list(frule) if m.sig <: Tuple{Any,Any,typeof(oa_id),Number}])
            # Opted out
            @assert !isempty([m for m in methods(frule) if m.sig <: Tuple{Any,Any,typeof(oa_id),Float32}])
            @test isempty([m for m in _rule_list(frule) if m.sig <: Tuple{Any,Any,typeof(oa_id),Float32}])
            # fallback
            @assert !isempty([m for m in methods(frule) if m.sig == Tuple{typeof(frule),Any,Any,Vararg{Any}}])
            @test isempty([m for m in _rule_list(frule) if m.sig == Tuple{typeof(frule),Any,Any,Vararg{Any}}])
        end
    end
end
