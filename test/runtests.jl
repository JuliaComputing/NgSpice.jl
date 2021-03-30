using NgSpice
using Test

rootdir = joinpath(@__DIR__, "..")
netpath = joinpath(rootdir, "inputs", "mosfet.cir")

@testset "interface" begin
    include("ngspice_api.jl")
end
