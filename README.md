[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=12143268&assignment_repo_type=AssignmentRepo)
# Astro 528 [Class Project](https://psuastro528.github.io/Fall2023/project/)

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://PsuAstro528.github.io/project-template/stable)

GitHub Actions : [![Build Status](https://github.com/PsuAstro528/project-template/workflows/CI/badge.svg)](https://github.com/PsuAstro528/project-template/actions?query=workflow%3ACI+branch%3Amain)


## Project Goals:  
- Create an N-body simulator of the solar system
- Utilize GPU acceleration

## Overview

This project takes data from the NASA JPL Horizons Database on Solar System objects and/or can create a uniform distribution of identical particles in a given spherical shell. The code calculates the acceleration from the position, velocity, and masses of the objects. This is then integrated through time using the Euler or Verlet algorithms.


## File Breakdown
- accel.jl has code to calculate the acceleration between bodies in the simulation
- bodies.jl contains the body struct, a cookie cutter for each mass in the system
- dictionaries.jl creates a dictionary containing all bodies in the simulation
- Euler_mainv2.jl contains the code to perform an Euler integration on the bodies in the simulation
- Eulerv2.jl performs ONE integration step for ONE body
- get_planet_data.jl obtains data on any body stored in the NASA Horizons database
- particles.jl creates a uniform distribution of identical particles in a spherical shell
- save.jl saves the position history of each body into jld2 files
- Verlet_main.jl performs Verlet integration on all bodies in the simulation

## Quick Use
- Open a julia terminal
- Create a list of names of the NASA Horizons Sun/Planets you want to include
- Run download_planet_data_from_list() from the get_planet_data.jl to download data from horizons
- Run either Verlet_main() or Euler_main() to perform a Verlet or Euler integration

## Class Project Schedule
- Project proposal (due Sept 6)
- Serial version of code (due Oct 2)
- Peer code review (due Oct 9)
- Parallel version of code (multi-core) (due Oct 30)
- Second parallel version of code (distributed-memory/GPU/cloud) (due Nov 13)
- Completed code, documentation, tests, packaging (optional) & reflection (due Nov 29)
- Class presentations (Nov 27 - Dec 6, [detailed schedule](https://github.com/PsuAstro528/PresentationsSchedule2023) )

