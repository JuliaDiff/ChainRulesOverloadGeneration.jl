# ForwardDiffZero
This is a fairly standard operator overloading-based forward mode AD system.
It defines a `Dual` part which holds both the primal value, paired with the partial derivative.
It doesn't handle chunked-mode, or perturbation confusion.
The overload generation hook in this example is: `define_dual_overload`.

````@eval
using Markdown
Markdown.parse("""
```julia
$(read(joinpath(@__DIR__,"../../../test/demos/forwarddiffzero.jl"), String))
```
""")
````
