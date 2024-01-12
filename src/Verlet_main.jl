include("bodies.jl")
include("accel.jl")
include("save.jl")
include("particles.jl")
include("dictionaries.jl")
using Pkg 
Pkg.add("JLD2")
using JLD2
using DataFrames







function Verlet_main(planet_names::Vector{String}, num_positions::Int64,use_particles::Bool=false, num_particles::Int64=0,min_radius::Float64=0, max_radius::Float64=0, mass::Float64=0,min_vel::Float64=0, max_vel::Float64=0)
    """
    Performs Verlet integration on all planets in planet_names for num_positions amount of iterations. 
    """

    bodies_dict = get_bodies_dict(planet_names, num_positions,use_particles, num_particles,min_radius, max_radius, mass,min_vel, max_vel) #dictionary with keys [planet_names] and values Body structs
    
    update_accels(bodies_dict) #get initial accelerations based on initial positions


    body_names = collect(keys(bodies_dict)) #puts names of all bodies in list
    
    iteration = 0
    time_step = 43200 #number of seconds in half day
    #perform Verlet integration for num_positions amount of steps
    while iteration < num_positions - 1 #subtract 1 because initial position is counted
        #position update for loop
        for body_name in body_names #perform step for all planets/particles

            body = bodies_dict[body_name]
            #update positions of each body
            r_next = body.position .+ body.velocity.*time_step .+ 1/2 .*body.acceleration.*time_step^2
            body.position = r_next

            
            #append new position to position_history matrix
            body.position_history[:,body.position_iter] = body.position
            

            body.position_iter += 1 


        end
        
        update_accels(bodies_dict)   #update acceleration now that all planets at new positions 




        #velocity half step update for loop
        for body_name in body_names #perform step for all planets/particles
            body = bodies_dict[body_name]
            #update velocities of v(a*1/2t^2) each body
            
            a_old = body.acceleration_history[:,body.position_iter-2] #position_iter - 2 bc accel iter is always -1 behind posit iter since accel depends on position, so previous accel is -2 from posit iter

            #calculate next velocity following verlet integration method
            v_next = body.velocity .+ 1/2 .*(a_old .+ body.acceleration).*time_step
            body.velocity = v_next

        end




        
        iteration += 1
    end
    save_all_jld2(bodies_dict) #save position history of all bodies in body_dict
    #save_gif(bodies_dict)

end















