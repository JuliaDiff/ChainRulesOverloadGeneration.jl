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
    sitename="ChainRules",
    authors="Lyndon White and other contributors",
    pages=[
        "Introduction" => "index.md",
        "API" => "api.md",
       ],
    strict=true,
    checkdocs=:exports,
)

deploydocs(
    repo = "github.com/JuliaDiff/ChainRulesOverloadGeneration.jl.git",
    push_preview=true,
)
