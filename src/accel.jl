include("get_planet_data.jl")
include("bodies.jl")
global G = 6.67*10^(-20) #kg*km^3/s^2
import LinearAlgebra: norm


function update_accels(planet_dict::Dict)
    """
    Updates accelerations for all planets in planet dict based on positions
    """
    @assert length(planet_dict)>=2 #cant calc accel unless at least 2 objects
    planets = collect(keys(planet_dict)) #puts names of planets in array
    static_planets = copy(planets) #a list of planet names that will not be changed
    #make all planet accels 0 so += operation can be performed without having history of old positions/accels affecting new one
    for planet in planets
        planet_dict[planet].acceleration = [0.0;0;0]
    end

    
    for planet1 in static_planets # goes through every planet
        filter!(x ->x !=planet1,planets) # remove planet1 from list so the other planets do not recalculate the interaction between them and this planet (i.e. merc-venus = venus-merc)
        for planet2 in planets #only goes through planets not yet covered in by planet1
            
            accel = get_accel(planet_dict[planet1],planet_dict[planet2])
            planet_dict[planet1].acceleration += -accel
            mass_ratio = planet_dict[planet1].mass/planet_dict[planet2].mass
            planet_dict[planet2].acceleration += mass_ratio.*accel

            #append accelerations to acceleration histories
            @assert (planet_dict[planet1].position_iter-1)>=1 #cant calc accurate accel unless at least one position in history
            @assert (planet_dict[planet2].position_iter-1)>=1
            planet_dict[planet1].acceleration_history[:,planet_dict[planet1].position_iter-1] = planet_dict[planet1].acceleration
            planet_dict[planet2].acceleration_history[:,planet_dict[planet2].position_iter-1] = planet_dict[planet2].acceleration
            
            
        end
    end
end





function get_accel(body1::Body, body2::Body)
    """
    Calculates acceleration of body2 caused by body 1
    """
    r = body2.position - body1.position
    @assert norm(r)!=0
    a_cur = -G*body2.mass.*r./(norm(r).^3)
    return a_cur
end
    