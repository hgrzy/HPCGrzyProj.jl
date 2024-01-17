include("../../get_planet_data.jl")
println("Installing NASA JPL Horizons Sun and Planet Data...")
body_names = ["Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
download_planet_data_from_list(body_names)
println("NASA JPL Horizons Data downloaded.")

