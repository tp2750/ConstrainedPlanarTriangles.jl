using Plots
using Printf
using Statistics

# function plot_triangle(t::Triangle)
#     ## points: (0,0), (c*cos(A), c*sin(A)), (b,0)
#     A = t.Angles[1]
#     (b,c) = t.Sides[2:3]
#     plot([0, c*cosd(A), b, 0], [0, c*sind(A), 0, 0])
# end

mk_pairs(x) = view.(Ref(x), (:).(1:length(x)-1,2:length(x))) ## from https://stackoverflow.com/a/63769989


@recipe function f(t::Triangle)
    (A,B,C) = t.Angles
    (a, b, c) = t.Sides
    ## @info "a=$a, b=$b, c=$c"
    x = [0, c*cosd(A), b, 0]
    y = [0, c*sind(A), 0, 0]
    angle_ann = [@sprintf("A=%.2f",A), @sprintf("B=%.2f",B), @sprintf("C=%.2f",C)]
    side_ann = [@sprintf("a=%.2f",a), @sprintf("b=%.2f",b), @sprintf("c=%.2f",c)]
    @series begin
        seriestype := :path
        label := ""
        x, y
    end
    @series begin
        seriestype := :scatter
        label := ""
        x, y
    end
    @series begin ## Angle names
        seriestype := :scatter
        label := ""
        series_annotations := angle_ann
        markersize := 0
        frac = 0.03
        x[1:3] .+ frac .* [b, -b, -b], y[1:3] .+ frac .* [a, -a, a]
    end
    @series begin ## side names
        seriestype := :scatter
        label := ""
        series_annotations := side_ann
        markersize := 0
        frac = 0.03
        x1 = mean.(mk_pairs(x)) 
        y1 = mean.(mk_pairs(y)) .+ frac .* [-a, a, -a]
        x1, y1
    end
end
