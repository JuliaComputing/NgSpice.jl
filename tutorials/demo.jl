# Check out mosfet.jl for more Julia-like usage

import NgSpice
n = NgSpice

netpath = joinpath(@__DIR__, "..", "inputs", "ac_ascii.cir") |> normpath

n.init()
n.cmd("source $netpath")
n.cmd("run")
n.cmd("display")
#n.cmd("<Standard Ngspice commands>")
