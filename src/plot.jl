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
    side_ann = [@sprintf("c=%.2f",c), @sprintf("a=%.2f",a), @sprintf("b=%.2f",b)]
    label := ""
    aspect_ratio := :equal
    @series begin
        seriestype := :path
        x, y
    end
    @series begin
        seriestype := :scatter
        x, y
    end
    @series begin ## Angle names
        seriestype := :scatter
        series_annotations := angle_ann
        markersize := 0
        frac = 0.01*(a+b+c)
        x[1:3] .+ frac .* [1, -1, -1], y[1:3] .+ frac .* [1, -1, 1]
    end
    @series begin ## side names
        seriestype := :scatter
        series_annotations := side_ann
        markersize := 0
        frac = 0.03
        x1 = mean.(mk_pairs(x)) 
        y1 = mean.(mk_pairs(y)) .+ frac .* [-1, 1, -1]
        x1, y1
    end
end
