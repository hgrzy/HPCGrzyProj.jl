include("get_planet_data.jl")
include("bodies.jl")
include("accel.jl")
include("particles.jl")


function get_bodies_dict(planet_names::Vector{String}, num_positions::Int64,use_particles::Bool=false, num_particles::Int64=0,min_radius::Float64=0, max_radius::Float64=0, mass::Float64=0,min_vel::Float64=0, max_vel::Float64=0)
    """
    Creates dictionary of format keys {body name as string} and values {Body struct} by obtaining values from horizons text files and creating particles randomly distributed within a shell of size min_radius to max_radius, each with mass mass, and velocity components (vx,vy,vz) distributed between min_vel and max_vel
    """
    @assert num_positions > 0 # need positive number of positions you want to keep in history
    @assert min_radius < max_radius
    @assert min_radius > 0 #need positive radius bc not a vector
    @assert mass > 0 
    @assert min_vel < max_vel #don't need min_vel > 0 bc it has direction
    
    if planet_names[1] != "None"
        total_body_num = size(planet_names)[1] + num_particles
    else
        total_body_num = num_particles
    end

    
    bodies_matrix = Array{Any}(undef,total_body_num,2) #type instability- fix later #array- each row has planet name, and body struct of planet
    empty_acc = [NaN;NaN;NaN]

    #create body objects from horizons data
    planet_index = 1
    if planet_names[1] != "None"
        for planet_name in planet_names
            planet_data = parse_planet_data(planet_name) #position and velocity wrt earth
            position_wrt_Sun, velocity_wrt_Sun = Earth_to_Sun_ref(planet_data["position"], planet_data["velocity"])
            planet_struct = Body(planet_data["mass"], position_wrt_Sun, velocity_wrt_Sun,empty_acc,num_positions)
            bodies_matrix[planet_index,:] = [planet_name;planet_struct] #put [planet name, body struct of planet] into planet matrix
            planet_index += 1
        end
    end


    #create body objects that are particles distributed in shell with velocity distribution determined by inputs
    if use_particles

        particle_masses, particle_posits,particle_vels = create_rand_particles(num_particles,min_radius, max_radius, mass,min_vel, max_vel)
        for particle_num in 1:num_particles
            particle_struct = Body(particle_masses[particle_num], particle_posits[:,particle_num],particle_vels[:,particle_num], empty_acc, num_positions)
            particle_name = "particle$particle_num"
            bodies_matrix[planet_index,:] = [particle_name;particle_struct] #put [planet name, body struct of planet] into planet matrix
            planet_index+=1
        end
    end
    bodies_dict = Dict(zip(bodies_matrix[:,1], bodies_matrix[:,2])) #convert matrix into dictionary with key planet name and value body struct of planet

    update_accels(bodies_dict)
    return bodies_dict


    
end

function Earth_to_Sun_ref(position_wrt_earth::Vector{Float64}, velocity_wrt_earth::Vector{Float64})
    """
    Horizons data uses coordinate system relative to Earth, this changes data so it is relative to sun
    """
    @assert sun_exists()
    Sun_data_rel_to_earth = parse_planet_data("Sun")
    Sun_r_rel_to_earth = Sun_data_rel_to_earth["position"]
    Sun_v_rel_to_earth = Sun_data_rel_to_earth["velocity"]

    position_wrt_Sun = position_wrt_earth - Sun_r_rel_to_earth
    velocity_wrt_Sun = velocity_wrt_earth - Sun_v_rel_to_earth

    return position_wrt_Sun, velocity_wrt_Sun
    


end

function sun_exists()
    """
    Checks to see if Sun.txt exists
    """
   body_dir = cd(pwd,"../body_txts")
   return isfile("$body_dir/Sun.txt")
end