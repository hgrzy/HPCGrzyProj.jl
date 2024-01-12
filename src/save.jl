include("bodies.jl")
using Pkg 
Pkg.add("JLD2")
using JLD2
using DataFrames


function save_single_jld2(body_name::String, body::Body)
    """
    Save position history of body to */position_saves/RunNum{run number} as jld2 file.
    """
    df = DataFrame(body.position_history, :auto)
    run_num = 1
    root = dirname(@__DIR__)
    filename = body_name*"_data.jld2"
    dir = root*"/position_saves/RunNum$run_num/"
    


    while isfile(dir)
        run_num+= 1
        dir = root*"/position_saves/RunNum$run_num/"

        println("dir: $dir")
    end
    path = root*"/position_saves/RunNum$run_num/"
    println("dir: $path")
    mkpath(path)
    cd(path)
    jldopen(filename, "w") do file
         file["df"] = df
       end
    save_loc = path*filename
    println("$body_name data saved to $save_loc")
    return df
end

function save_all_jld2(bodies_dict::Dict)
    """
    Save position history of all bodies in bodies_dict to */position_saves/RunNum{run number} as jld2 file.
    """
    body_names = collect(keys(bodies_dict))
    for body in body_names
        save_single_jld2(body,bodies_dict[body])
    end
end


####UNDER CONSTRUCTION
# function save_gif(planet_dict::Dictionary)
# 	anim = @animate for i ∈ 1:20
# 	ind = 20*(i-1)+1
#     planet_names = collect(keys(planet_dict))

#     sunx, suny, sunz = planet_dict["Sun"].position_history[1,ind:ind+1],planet_dict["Sun"].position_history[2,ind:ind+1],planet_dict["Sun"].position_history[3,ind:ind+1]
            
# 	scatter(sunx,suny,sunz, markersize = 5, xlims =[-1.75e8,1.75e8], ylims = [-1.75e8,1.75e8], zlims = [-1.75e8,1.75e8])
            
#     for planet in planet_names
#         scatter!(planet_dict[planet].position_history[1,ind:ind+1].-sunx,planet_dict[planet].position_history[2,ind:ind+1].-suny,planet_dict[planet].position_history[3,ind:ind+1].-sunz, label = "$planet")
#     end
#     end

#     root = dirname(@__DIR__)
#     dir = root*"/animation/planets_animation.gif"
# 	gif(anim, dir, fps = 15)
# end
