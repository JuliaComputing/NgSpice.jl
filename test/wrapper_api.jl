using NgSpice
using Test

rootdir = joinpath(@__DIR__, "..")
netpath = joinpath(rootdir, "inputs", "mosfet.cir")

@testset "initialize" begin
    init()
    @test source(netpath) == 0
    @test NgSpice.run() == 0
end

@testset "getvectors" begin
    # as this simulation runs after the one in `ngspice_api.jl`, 
    # `tran2` is the current plot
    @test curplot() == "tran2"
    @test listallplots() == ["tran2", "tran1", "const"]
    @test collect(keys(listallvecs())) == collect(sort(listallplots()))
    @test listallvecs()[curplot()] == listcurvecs()
    @test getvec.(listcurvecs()) == get_vector_info.(listcurvecs())
    #listcurvecs()
    for node in split("V(1) emit coll base vcc")
        @test getvec(node)[2] == "voltage"
    end
    for branch in split("vcc#branch vin#branch")
        @test getvec(branch)[2] == "current"
    end
    @test getvec("time")[2] == "time"
end

@testset "passing circuit as an array" begin
    netlist = readlines(netpath)
    @test load_netlist(netlist) == 0
end
