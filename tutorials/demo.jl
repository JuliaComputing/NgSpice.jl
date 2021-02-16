# To run the NgSpice in non-interactive mode (aka as Julia functions)

import NgSpice as n

netpath = joinpath(@__DIR__, "..", "inputs/ac_ascii.cir") |> normpath

n.init()
n.cmd("source $netpath")
n.cmd(:run)
n.cmd(:display)
