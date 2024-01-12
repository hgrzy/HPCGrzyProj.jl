using Test, HPCGrzyProj
include("../src/dictionaries.jl")
include("../src/accel.jl")
include("../src/bodies.jl")


# Add your tests below




@testset "Test Earth2Sun Frame" begin
    if sun_exists()
        Sun_data_rel_to_earth = parse_planet_data("Sun")
        Sun_r_rel_to_earth = Sun_data_rel_to_earth["position"]
        Sun_v_rel_to_earth = Sun_data_rel_to_earth["velocity"]
        @test Earth_to_Sun_ref(Sun_r_rel_to_earth, Sun_v_rel_to_earth) ≈ 0 atol = 1e-8
    end
end;



@testset "Test Accelerations" begin
    body1 = Body(2.0, [0.0;0;0], [2;3.0;4],[1;2;3.0],2)
    body2 = Body(4.0, [3.0;4;2], [1;4.0;5],[3;0;2.0],2)
    @test get_accel(body1,body2) ≈ [-5.12*10^(-21);-6.83*10^(-21);-3.41*10^(-21)] atol = 1e-8
end;




@testset "Test r = 0 " begin
    body1 = Body(2.0, [0.0;0;0], [2;3.0;4],[1;2;3.0],2)
    body2 = Body(4.0, [0.0;0;0], [1;4.0;5],[3;0;2.0],2)
    @test_throws AssertionError get_accel(body1,body2)
end;



# julia-actions/julia-runtest
touch(joinpath(ENV["HOME"], "julia-runtest"))