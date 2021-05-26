# ReverseDiffZero

This is a fairly standard operator overloading based reverse mode AD system.
It defines a `Tracked` type which carries the primal value as well as a reference to the tape which is it using, a partially accumulated partial derivative and a `propagate` function that propagates its partial back to its input.
A perhaps unusual thing about it is how little it carries around its creating operator's inputs.
That information is all entirely wrapped up in the `propagate` function.
The overload generation hook in this example is: `define_tracked_overload`.

````@eval
using Markdown
Markdown.parse("""
```julia
$(read(joinpath(@__DIR__,"../../../test/demos/reversediffzero.jl"), String))
```
""")
````
