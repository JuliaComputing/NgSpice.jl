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
    @test curplot() == "tran1"
    @test listallplots() == ["tran1", "const"]
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

@testset "exit" begin
    @test NgSpice.exit() == 0
end

@testset "passing circuit as an array" begin
    init()
    netlist = readlines(netpath)
    @test load_netlist(netlist) == 0
    NgSpice.exit()
end
