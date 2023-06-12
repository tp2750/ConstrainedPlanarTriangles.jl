# ConstrainedPlanarTriangles

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tp2750.github.io/ConstrainedPlanarTriangles.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tp2750.github.io/ConstrainedPlanarTriangles.jl/dev/)
[![Build Status](https://github.com/tp2750/ConstrainedPlanarTriangles.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/tp2750/ConstrainedPlanarTriangles.jl/actions/workflows/CI.yml?query=branch%3Amain)

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

```

# TODO
* sine relations: given 2 angles and one opposing side, find other opposing side
  - this solves 3 angles + 1 side
* use and report heights
* use and report area
* parse kwargs in loop
* update vectors in functions
* call functions repeatedly until done or give up.
  - Needs to generate kwargs. See https://discourse.julialang.org/t/how-to-programmatically-generate-different-functions/78152 ?
* report inconsistent. eg triangle(a=1, b=2, c=4)
* report underdetermined. eg A, B, C
* relative constrains. Eg B == C or A == B/2.
  - idea: string macro as positional argument: constraint"B == A/2, c == 2b"
* plot method 
