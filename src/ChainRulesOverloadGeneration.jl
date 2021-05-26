using ChainRulesCore

export on_new_rule, refresh_rules

include("precompile.jl")
include("ruleset_loading.jl")

function __init__()
    # Need to refresh rules when a package is loaded
    push!(Base.package_callbacks, _package_hook)
end

end
