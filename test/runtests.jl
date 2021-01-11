using Ngspice
using Test

fpgen(a, fp) = (a=a; convert(Ptr{fp}, a))

@testset "Ngspice.jl" begin
    p = fpgen(0, Nothing)
    @test ngSpice_Init(p, p, p, p, p, p, p) == 0
    @test ngSpice_Command("bg_run") == 0
    #@test typeof(ngGet_Vec_Info("vecname")) <: Ptr{Ngspice.vector_info}
        # returns false despite the same type
    @test_throws MethodError ngSpice_Circ("circarray") 
        #unsafe_wrap needs to be defined for ::Type{Ptr{String}}
    @test typeof(ngSpice_CurPlot()) <: Cstring
    @test typeof(ngSpice_AllPlots()) <: Ptr{Cstring}
    @test typeof(ngSpice_AllVecs("plotname")) <: Ptr{Cstring}
    @test ngSpice_running() == 0
    @test ngSpice_SetBkpt() == 0
end

