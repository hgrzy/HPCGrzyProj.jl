include("Eulerv2.jl")
include("get_planet_data.jl")
include("bodies.jl")
include("accel.jl")
include("save.jl")
include("particles.jl")
include("dictionaries.jl")
using Pkg 
Pkg.add("JLD2")
using JLD2
using DataFrames




function Euler_main(planet_names::Vector{String}, num_positions::Int64,use_particles::Bool=false, num_particles::Int64=0,min_radius::Float64=0, max_radius::Float64=0, mass::Float64=0,min_vel::Float64=0, max_vel::Float64=0)
    """
    Performs Euler integration on all planets in planet_names for num_positions amount of iterations. 
    """

    bodies_dict = get_bodies_dict(planet_names, num_positions,use_particles, num_particles,min_radius, max_radius, mass,min_vel, max_vel) #dictionary with keys [planet_names] and values Body structs
    
    update_accels(bodies_dict) #get initial accelerations based on initial positions


    body_names = collect(keys(bodies_dict)) #puts names of all bodies in list
    
    iteration = 0
    time_step = 43200 #number of seconds in half day
    #perform Euler integration for num_positions amount of steps
    while iteration < num_positions - 1 #subtract 1 because initial position is counted
        for body_name in body_names #perform step for all planets/particles
Euler_Integrate(bodies_dict[body_name],time_step)
        end
        update_accels(bodies_dict)   #update acceleration now that all planets at new positions   
        iteration += 1
    end
    save_all_jld2(bodies_dict)

end















