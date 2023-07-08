module ConstrainedPlanarTriangles

using Missings

const A = string.('A':'C')
const s = string.('a':'c')

# include("draft.jl")

include("structs.jl")
export triangle, Triangle

include("plot.jl")


end
