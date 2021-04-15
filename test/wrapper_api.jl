@testset "initialize" begin
    init()
    @test source(netpath) == 0
    @test NgSpice.run() == 0
end

@testset "getvectors" begin
    @test curplot() == "tran2"
    @test listallplots() == ["tran2", "tran1", "const"]
    @test collect(keys(listallvecs())) == collect(sort(listallplots()))
    @test listallvecs()[curplot()] == listcurvecs()
    @test getvec.(listcurvecs()) == get_vector_info.(listcurvecs())
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
