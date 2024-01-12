# Simulating in a 3-dimensional world
NUM_DIMENSIONS = 3

# Define a struct to hold the values of your bodies
@kwdef mutable struct Body
    mass::Float64
    position::Vector{Float64}
    velocity::Vector{Float64}
    acceleration::Vector{Float64}
    position_history::Matrix{Float64}
    acceleration_history::Matrix{Float64}
    position_iter::Int64=1
    
    

    # Constructor for initializing the history arrays with the correct size
    function Body(
        mass::Float64,
        current_position::Vector{Float64},
        current_velocity::Vector{Float64},
        current_acceleration::Vector{Float64},
        history_size::Int64,
        position_iter::Int64=1
        
    )
        #history_size- number of records you want to keep
        
        # The order here is important (NUM_DIMENSIONS, history_size) ensures that the matrix is accessed
        # column-wise. 
        @assert mass>0 #need positive non-zero mass
        @assert history_size > 0 #need positive number of records you want to keep
        @assert position_iter > 0 #can only have a positive iterator number
        
        position_history = zeros((NUM_DIMENSIONS, history_size))
        acceleration_history = zeros((NUM_DIMENSIONS, history_size))

        position_history[:,position_iter] = current_position


        position_iter += 1

        return new(mass, current_position, current_velocity,current_acceleration, position_history, acceleration_history, position_iter)
    end
end