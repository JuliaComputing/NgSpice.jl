__precompile__()
module Ngspice

using ngspice_jll
export ngspice_jll

#=
# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("Ngspice was not built properly. Please run Pkg.build(\"Ngspice\").")
end
include(depsjl_path)
# Module initialization function
function __init__()
    check_deps()
end=#

using CEnum

include("interface/ctypes.jl")
export Ctm, Ctime_t, Cclock_t

include("interface/ngspice_common.jl")
include("interface/ngspice_api.jl")

export BGThreadRunning, GetISRCData, GetSyncData, GetVSRCData, 
       SendChar, SendData, SendStat, SendInitData

foreach(names(@__MODULE__, all=true)) do s
    if startswith(string(s), "ng")
        @eval export $s
    end
end

include("API/running.jl")
include("API/plots.jl")
include("API/netlist.jl")

export halt, init, isrunning, reset, run, start, stop

end
