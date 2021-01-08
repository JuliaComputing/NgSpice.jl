using Ngspice
using Test

@testset "Ngspice.jl" begin
    @test_throws ReadOnlyMemoryError ngSpice_Command("command")
    @test_throws ReadOnlyMemoryError ngGet_Vec_Info("vecname")
    @test_throws MethodError ngSpice_Circ(circarray) 
        #unsafe_wrap needs to be defined for ::Type{Ptr{String}}
    @test typeof(ngSpice_CurPlot()) <: Cstring
    @test_throws ReadOnlyMemoryError ngSpice_AllPlots() 
        #Leaves no stacktrace
    @test typeof(ngSpice_AllVecs("plotname")) <: Ptr{Cstring}
    @test ngSpice_running() == 0
    @test ngSpice_SetBkpt() == 0
end

