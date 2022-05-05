using NgSpice
using Test
using SafeTestsets

@safetestset "interface functions" begin
    include("ngspice_api.jl")
end

@testset "friend functions" begin
    include("wrapper_api.jl")
end

@safetestset "wrapper safetests" begin
    include("wrapper_safetests.jl")
end

using Aqua
Aqua.test_all(NgSpice; undefined_exports = false, stale_deps = false)