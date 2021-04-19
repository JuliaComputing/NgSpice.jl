using NgSpice
using Test

rootdir = joinpath(@__DIR__, "..")
netpath = joinpath(rootdir, "inputs", "mosfet.cir")

@testset "interface" begin
    p = convert(Ptr{Nothing}, 0)
    @test ngSpice_Init(p, p, p, p, p, p, p) == 0
    @test ngSpice_Command("source $netpath") == 0
    @test ngSpice_CurPlot() != C_NULL
    @test ngSpice_Command("run") == 0
    @test typeof(ngSpice_AllPlots()) == Ptr{Ptr{UInt8}}
    @test ngSpice_running() == 0
    @test ngSpice_Command("unset askquit") == 0
end