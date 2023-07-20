mutable struct Triangle
    Angles::Vector{Float64}
    Sides::Vector{Float64}
end

function Triangle(;kwargs...)
    t1 = triangle(;kwargs...)
    Triangle(t1[:Angles], t1[:Sides])
end

const ABC = ["A","B","C"]
const abc = ["a", "b", "c"]

function triangle(;kwargs...)
    @debug kwargs
    angles = missings(Float64,3)
    sides = missings(Float64,3)
    # parse input. There must be a better way
    haskey(kwargs,:A) && (angles[1] = kwargs[:A])
    haskey(kwargs,:B) && (angles[2] = kwargs[:B])
    haskey(kwargs,:C) && (angles[3] = kwargs[:C])
    haskey(kwargs,:a) && (sides[1] = kwargs[:a])
    haskey(kwargs,:b) && (sides[2] = kwargs[:b])
    haskey(kwargs,:c) && (sides[3] = kwargs[:c])
    ## check consistencies    
    check_input(angles, sides)
    ## 2 angles determine the last
    missing_angles = findall(ismissing, angles)
    if length(missing_angles) == 1
        the_missing = first(missing_angles)
        angles[the_missing] = 180 - sum(angles[setdiff([1,2,3], [the_missing])])
    end
    ## check again after infering all angles
    check_input(angles, sides)
    ## 2 sides and enclosed angle determines the last: c² = a² + b² - 2ab cos(c)
    missing_sides = findall(ismissing, sides)
    if length(missing_sides) == 1
        @debug "cos"
        the_missing = first(missing_sides)
        if ! ismissing(angles[the_missing])
            @debug "cos1"
            known_sides = sides[setdiff([1,2,3], [the_missing])]
            known_angle = angles[the_missing]
            sides[the_missing] = sqrt(sum(known_sides.^2) - 2*prod(known_sides)*cosd(known_angle))
        else
            ## 2 sides and non-enclosed angle (so opposing side known)
            ## 1*a^2 - 2*b*cos(C)*a + (b^2 -c^2)
            ## take first known opposing angle
            @debug "cos2"
            known_side_idxs = setdiff([1,2,3], [the_missing])
            known_sides = sides[known_side_idxs]
            known_angle_idxs = findall(!ismissing, angles)
            ## opposing_angle_idx = findfirst(!ismissing,angles[known_side_idxs])
            opposing_angle_idx = first(intersect(known_side_idxs, known_angle_idxs))
            opposing_angle = angles[opposing_angle_idx] |> first
            opposing_side = sides[opposing_angle_idx] |> first
            non_opposing_side = sides[setdiff([1,2,3], [the_missing, opposing_angle_idx])] |> first
            @debug "Known sides: $(abc[known_side_idxs]), Known Angles: $(ABC[known_angle_idxs]), Opposing_angle: $(ABC[opposing_angle_idx]), Non-opposing side length: $(non_opposing_side). Missing side: $(abc[the_missing]), Opposing side length: $(opposing_side)"
            sides[the_missing] = solve_quadratic(1, -2*non_opposing_side*cosd(opposing_angle), non_opposing_side^2 - opposing_side^2)[end]
        end
    end
    ## 2 angles and one opposing side, find other opposing side (law of sines)
    ## if we had 2 angles, we now have all 3
    missing_sides = findall(ismissing, sides)
    while 3 > length(missing_sides) > 0
        side_to_find = findfirst(ismissing, sides)
        known_side = findfirst(!ismissing, sides)
        ## call with side_to_find, known_side and opposing angles
        @debug "unknown side = $side_to_find, known side = $known_side"
        side_from_angles!(sides, angles, side_to_find, known_side)
        missing_sides = findall(ismissing, sides)        
    end
    ## all sides determine all angles
    if isnothing(findfirst(ismissing, sides))
        for i in findall(ismissing, angles)
            angle_from_sides!(angles, sides, i)
        end
    end
    Dict(:Angles => angles, :Sides => sides)
end

function side_from_angles!(sides, angles, side_to_find, known_side)
    ## sides, angles are vector refs
    ## use sine relations:
    ## a/sin(A) = b/sin(B) = c/sin(C)
    sides[side_to_find] = (sides[known_side] / sind(angles[known_side])) * sind(angles[side_to_find])
end

function angle_from_sides!(angles, sides, angleindex)
    ## use cosine relations:
    ## cos C = (a² + b² - c²)(2ab)
    @assert isnothing(findfirst(ismissing, sides)) # no missing sides
    other_indices = setdiff([1,2,3], [angleindex])
    near_sides = sides[other_indices]
    cosC = (sum(near_sides.^2) - sides[angleindex]^2)/(2*prod(near_sides))
    angles[angleindex] = acosd(cosC)
    angles
end
    
function solve_quadratic(a,b,c) ## positive solution last (if one exists)
    d = sqrt(b^2 -4*a*c)
    sort([(-b - d), (-b + d)] / (2*a))
end

import Base.deg2rad
deg2rad(::Missing) = missing

function check_input(angles, sides)
    ## sum of angles <= 180
    @debug "check angle sum $(sum(skipmissing(angles)))"
    if (anglesum = sum(skipmissing(angles))) > 180
        error("sum of angles = $(anglesum) > 180")
    end
    ## if all angles, sum must be 180
    if (sum(.!ismissing.(angles)) == 3) && (sum(angles) != 180)
        error("all angles specified and sum of angles: $(sum(angles)) != 180")
    end
    ## trangle inequality
    if (sum(.!ismissing.(sides)) == 3)
        ssides = sort(sides)
        if ssides[3] > (ssides[1] + ssides[2])
            error("Triangle equality violated: $(ssides[3]) > $(ssides[1]) + $(ssides[2])")
        end
    end
    ## degrees of freedom
    constraints = min(2, sum(.!ismissing.(angles))) + sum(.!ismissing.(sides))
    if constraints < 3
        @warn("Under specified. Only $constraints constraints specified.")
    end
    if constraints > 3
        @warn("Over specified: $constraints values specified.")
    end
    ## law of sines must hold for over-contrained
    ## check again after infering all angles
    both_known = .!ismissing.(angles) .& .!ismissing.(sides)
    if sum(both_known) > 1
        @info "over-specified. Checking law of sines"
        @info "Known pairs: $(A[both_known]), $(s[both_known])"
    end
    sine_check = sind.(angles) ./ sides
    if !allequal(skipmissing(sine_check))
        error( "Sine check failed: $sine_check")
    end
    @debug "input check done"
end
