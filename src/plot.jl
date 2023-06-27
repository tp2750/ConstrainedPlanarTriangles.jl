using Plots



function plot_triangle(t::Triangle)
    ## points: (0,0), (c*cos(A), c*sin(A)), (b,0)
    A = t.Angles[1]
    (b,c) = t.Sides[2:3]
    plot([0, c*cosd(A), b, 0], [0, c*sind(A), 0, 0])
end


@recipe function f(t::Triangle)
    A = t.Angles[1]
    (b,c) = t.Sides[2:3]
    @series begin
        x := [0, c*cosd(A), b, 0]
        y := [0, c*sind(A), 0, 0]
        seriestype := :scatter
    end
end
