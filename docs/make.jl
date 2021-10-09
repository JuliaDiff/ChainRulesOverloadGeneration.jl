using ChainRulesOverloadGeneration
using ChainRulesCore: ChainRulesCore
using Documenter
using DocThemeIndigo
using Markdown

indigo = DocThemeIndigo.install(ChainRulesOverloadGeneration)

makedocs(
    modules=[ChainRulesOverloadGeneration],
    format=Documenter.HTML(
        prettyurls=false,
        assets=[indigo],
    ),
    sitename="ChainRules Overload Generation",
    authors="Lyndon White and other contributors",
    pages=[
        "Introduction" => "index.md",
        "Examples of making AD systems" => [
            "Forward Mode" => "examples/forward_mode.md",
            "Reverse Mode" => "examples/reverse_mode.md",
        ],
        "API" => "api.md",
       ],
    strict=true,
    checkdocs=:exports,
)

deploydocs(
    repo = "github.com/JuliaDiff/ChainRulesOverloadGeneration.jl.git",
    push_preview=true,
    devbranch="main",
)
