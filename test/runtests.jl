using NgSpice
using Test

rootdir = joinpath(@__DIR__, "..")
netpath = joinpath(rootdir, "inputs", "mosfet.cir")

@testset "interface functions" begin
    include("ngspice_api.jl")
end

@testset "friend functions" begin
    include("wrapper_api.jl")
end
