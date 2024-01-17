import Pkg; Pkg.add("HTTP")
using HTTP


horizons_id_dict = Dict{String,Int64}("Sun"=>10, "Mercury" => 199, "Venus" => 299, "Earth" => 399, "Mars" => 499, "Jupiter"=>599, "Saturn" => 699, "Uranus"=>799, "Neptune"=>899)

function download_planet_data(name::String, overwrite::Bool = false, override_id::Int64 = 0 )
    """
    Downloads data from NASA JPL Horizons and puts this data in a txt file using HTTP.jl. Can either just insert name of planet or sun as string OR set overwrite = true and use the NASA Horizons ID for objects other than the Sun and the 8 planets. Credit to Kadri for all of the open() HTTP.request stuff.
    """
    begin
        if override_id != 0
            println("Override id detected. The program will attempt to obtain this id from the Horizons database but you should check the $name.txt file to ensure (1)  this is the object you want and (2) it was obtained properly")
            id = override_id
        else
            id = horizons_id_dict[name]
        end
        
        if (isfile("body_txts/$name.txt") && overwrite == false)
            println("$name data file already downloaded. No changes made.")
        else
            if (isfile("body_txts/$name.txt") && overwrite == true)
                            println("$name file already exists, overwriting...")
            end
        io = open("body_txts/$name.txt", "w")
        r = HTTP.request("GET", "https://ssd.jpl.nasa.gov/api/horizons.api?format=text&COMMAND='$id'&OBJ_DATA='YES'&MAKE_EPHEM='YES'&EPHEM_TYPE='VECTOR'&START_TIME='2006-01-01'&STOP_TIME='2006-01-20'&STEP_SIZE='1%20d'&QUANTITIES='1'", response_stream=io)
        close(io)
        #println(read("body_txts/$name.txt", String)) #uncomment to see what it saved in text file
        println("$name data downloaded.")

        end
    end

end


function download_planet_data_from_list(names::Vector{String})
    """
    Takes list of planet names and downloads each respective Horizons database file.
    """
    for name in names
        download_planet_data(name)
    end

end

function parse_planet_data(planet_name::String)
    """
    Parses text files of planet data from horizons for ::Body attributes. Credit to Kadri for all regex stuff.
    """
    data_file_name = "body_txts/" * planet_name * ".txt"
    if !isfile(data_file_name)
        println("Planet data not found, please try a different planet name.")
        return
    end
        
    #credit to Kadri for following code
    # Read in the raw strings
    raw = open(io->read(io, String), data_file_name);
    
    
    # The regex matches the different lines in the data file, capturing only the values of eachmatch
    # property. We'll later cast the captured values to floats later.
    #
    # https://regex101.com/r/l7Yr0E/1
    mass_regex = r"Mass.*x? ?((?:10 )?\^\d\d)[^=]+=[\~\s]+([\d\.\+\- ]+)"
    position_regex = r"X ?= ?(.*) Y ?= ?(.*) Z ?= ?(.*)"
    velocity_regex = r"VX ?= ?(.*) VY ?= ?(.*) VZ ?= ?(.*)"
    lt_rg_rr_regex = r"LT ?= ?(.*) RG ?= ?(.*) RR ?= ?(.*)"
    
    # Mass is only a single float
    # mass = parse.(Float64, match(mass_regex, raw).captures)
    mass,_ = parse_mass_string(mass_regex,raw)
    
    # Data is now in column major order i.e. position[:, 1] = X[1], Y[1], Z[1] and so it goes
    position = stack(map(x -> parse.(Float64, x.captures), eachmatch(position_regex, raw)))[:,1]
    velocity = stack(map(x -> parse.(Float64, x.captures), eachmatch(velocity_regex, raw)))[:,1]
    lt_rg_rr = stack(map(x -> parse.(Float64, x.captures), eachmatch(velocity_regex, raw)))[:,1]

    planetDict = Dict("mass" => mass, "position" => position, "velocity" => velocity, "lt_rg_rr" => lt_rg_rr) 
    return planetDict
    
end

function parse_mass_string(MASS_REGEX,mass_string)
    """
    Parses text file mass data string for mass. Credit to Kadri for all regex stuff.
    """

    # Match the Regular Expression to the string
    exponent_string, mass_string = match(MASS_REGEX, mass_string)

    # println("Extracted mass as: ", mass_string)
    # println("Extracted exponent as: ", exponent_string)

    # Split the extracted strings where necessary and typecast them into Float64
    mass, uncertainty... = parse.(Float64, split(mass_string, "+-", keepempty=false))
    base..., exponent = parse.(Float64, split(exponent_string, "^", keepempty=false))

    # Construct the multiplier before-hand to reduce code duplication
    multiplier = if isempty(base) 10 ^ exponent else first(base) ^ exponent end

    # Now get the mass and the uncertainty if available. The latter defaults to 0
    uncertainty = if isempty(uncertainty) 0 else first(uncertainty) * multiplier end
    mass = mass * multiplier


    return mass, uncertainty
end


println("Installing NASA JPL Horizons Sun and Planet Data...")
body_names = ["Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
download_planet_data_from_list(body_names)
println("NASA JPL Horizons Data downloaded.")