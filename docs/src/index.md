```@meta
CurrentModule = ConstrainedPlanarTriangles
```

# ConstrainedPlanarTriangles

Documentation for [ConstrainedPlanarTriangles](https://github.com/tp2750/ConstrainedPlanarTriangles.jl).

Very primitive package for applying elemetary geometry to find to missing angles or sides in a triangle.

The interface is intuitive, the 3 angles are called A, B, C and the sides lengths a, b, c.

Here are some examples:

```julia
julia> triangle(C=90, a=3, b=4)
Dict{Symbol, Vector{Union{Missing, Float64}}} with 2 entries:
  :Sides  => [3.0, 4.0, 5.0]
  :Angles => [36.8699, 53.1301, 90.0]

julia> triangle(C=60, a=4, b=4)
Dict{Symbol, Vector{Union{Missing, Float64}}} with 2 entries:
  :Sides  => [4.0, 4.0, 4.0]
  :Angles => [60.0, 60.0, 60.0]

julia> triangle(a=3, b=3, c=3)
Dict{Symbol, Vector{Union{Missing, Float64}}} with 2 entries:
  :Sides  => [3.0, 3.0, 3.0]
  :Angles => [60.0, 60.0, 60.0]

julia> triangle(A=30, B=60)
Dict{Symbol, Vector{Union{Missing, Float64}}} with 2 entries:
  :Sides  => [missing, missing, missing]
  :Angles => [30.0, 60.0, 90.0]

julia> triangle(;C = 90, a=3, b=4)
Dict{Symbol, Vector{Union{Missing, Float64}}} with 2 entries:
  :Sides  => [3.0, 4.0, 5.0]
  :Angles => [36.8699, 53.1301, 90.0]

julia> triangle(;A=60, B=60, c=10)
[ Info: unknown side = 1, known side = 3
[ Info: unknown side = 2, known side = 1
Dict{Symbol, Vector{Union{Missing, Float64}}} with 2 entries:
  :Sides  => [10.0, 10.0, 10.0]
  :Angles => [60.0, 60.0, 60.0]

```


```@index
```

```@autodocs
Modules = [ConstrainedPlanarTriangles]
```
