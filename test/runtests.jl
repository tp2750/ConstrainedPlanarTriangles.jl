using ConstrainedPlanarTriangles
using Test

@testset "ConstrainedPlanarTriangles.jl" begin
    @test Triangle(C=90, a=3, b=4).Sides == [3.0, 4.0, 5.0]
    @test Triangle(C=60, a=4, b=4).Sides == [4.0, 4.0, 4.0]
    @test Triangle(a=3, b=3, c=3).Angles ≈ [60., 60., 60.]
    @test Triangle(C = 90, a=3, b=4).Sides == [3.0, 4.0, 5.0]
    @test Triangle(A=60, B=60, c=10).Sides == [10., 10. ,10.]
end

@testset "Partial" begin
    @test triangle(A=30, B=60)[:Angles] == [30., 60., 90.]
end

