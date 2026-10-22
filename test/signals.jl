using NgSpice
using Test

# libngspice 41 re-installs Julia's SIGSEGV handler with signal() during
# ngSpice_Init, dropping SA_SIGINFO|SA_ONSTACK. Julia then cannot recognise its
# own GC safepoint faults, and any multi-threaded GC can crash the process.
# NgSpice.jl must restore Julia's handlers after every call into the library.

rootdir = joinpath(@__DIR__, "..")
netpath = joinpath(rootdir, "inputs", "mosfet.cir")

@testset "Julia signal handlers survive ngspice" begin
    if Sys.islinux()
        @test NgSpice.segv_handler_intact()
        NgSpice.init()                       # calls ngSpice_Init again
        @test NgSpice.segv_handler_intact()
        @test NgSpice.source(netpath) == 0
        @test NgSpice.run() == 0
        @test NgSpice.cmd("let x = 2*time") == 0   # exercises the expression evaluator
        @test NgSpice.segv_handler_intact()
    else
        @test_skip false
    end
end

@testset "load_netlist does not modify its argument" begin
    nl = readlines(netpath)
    copy_nl = copy(nl)
    @test NgSpice.load_netlist(nl) == 0
    @test nl == copy_nl
end
