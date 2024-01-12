

function create_rand_particles(num_particles::Int64=0,min_radius::Float64=0, max_radius::Float64=0, mass::Float64=0,min_vel::Float64=0, max_vel::Float64=0)
    particle_masses = rand(num_particles).*mass
    particle_posits =rand(3, num_particles).*(max_radius-min_radius).+min_radius
    particle_vels = rand(3, num_particles).*(max_vel-min_vel).+min_vel
    # particle_masses = mass
    # particle_posits = [-1.5*10^7,-1.9*10^8,-5.6*10^5]
    # particle_vels = [0,0.0,0.0]

    return particle_masses, particle_posits, particle_vels
end