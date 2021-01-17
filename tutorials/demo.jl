#This simulates the ac_ascii file

import Ngspice as n

netpath = joinpath(@__DIR__, "..", "inputs/vdiv.cir") |> normpath

n.init()
n.cmd("source $netpath")
n.cmd(:display)
n.cmd(:run)
