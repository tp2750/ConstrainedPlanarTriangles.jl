using ConstrainedPlanarTriangles
using Test

@testset "ConstrainedPlanarTriangles.jl" begin
    @test triangle(A=30, B=60)[:Angles] == [30., 60., 90.]
    @test triangle(C=90, a=3, b=4)[:Sides] == [3.0, 4.0, 5.0]
    @test triangle(C=60, a=4, b=4)[:Sides] == [4.0, 4.0, 4.0]
    @test triangle(a=3, b=3, c=3)[:Angles] ≈ [60., 60., 60.]
end
