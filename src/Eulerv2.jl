include("bodies.jl")
include("accel.jl")




"""
Euler Method
"""

function Euler_Integrate(planet::Body,time_step)

    """
    Performs one Euler Integration for given planet by time_step time.
    """
        

    r_old = planet.position
    v_old = planet.velocity

    
    
    planet.position = r_old .+ v_old .* time_step
    planet.velocity = v_old .+ planet.acceleration*time_step

    #append new position to planet_history matrix
    planet.position_history[:,planet.position_iter] = planet.position
    planet.velocity_history[:,planet.position_iter] = planet.velocity
    planet.position_iter += 1


    
    
end 








