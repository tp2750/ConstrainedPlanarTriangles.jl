mutable struct Triangle
    Angles::Vector{Float64}
    Sides::Vector{Float64}
end

function Triangle(;kwargs...)
    t1 = triangle(;kwargs...)
    Triangle(t1[:Angles], t1[:Sides])
end

function triangle(;kwargs...)
#    @info kwargs
    angles = missings(Float64,3)
    sides = missings(Float64,3)
    # parse input. There must be a better way
    haskey(kwargs,:A) && (angles[1] = kwargs[:A])
    haskey(kwargs,:B) && (angles[2] = kwargs[:B])
    haskey(kwargs,:C) && (angles[3] = kwargs[:C])
    haskey(kwargs,:a) && (sides[1] = kwargs[:a])
    haskey(kwargs,:b) && (sides[2] = kwargs[:b])
    haskey(kwargs,:c) && (sides[3] = kwargs[:c])
    ## 2 angles determine the last
    missing_angles = findall(ismissing, angles)
    if length(missing_angles) == 1
        the_missing = first(missing_angles)
        angles[the_missing] = 180 - sum(angles[setdiff([1,2,3], [the_missing])])
    end
    ## 2 sides and enclosed angle determines the last: c² = a² + b² - 2ab cos(c)
    missing_sides = findall(ismissing, sides)
    if length(missing_sides) == 1
        the_missing = first(missing_sides)
        if ! ismissing(angles[the_missing])
            known_sides = sides[setdiff([1,2,3], [the_missing])]
            known_angle = angles[the_missing]
            sides[the_missing] = sqrt(sum(known_sides.^2) - 2*prod(known_sides)*cosd(known_angle))
        end
    end
    ## 2 angles and one opposing side, find other opposing side (law of sines)
    ## if we had 2 angles, we now have all 3
    missing_sides = findall(ismissing, sides)
    while 3 > length(missing_sides) > 0
        side_to_find = findfirst(ismissing, sides)
        known_side = findfirst(!ismissing, sides)
        ## call with side_to_find, known_side and opposing angles
        @info "unknown side = $side_to_find, known side = $known_side"
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
    

