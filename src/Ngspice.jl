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

include("ctypes.jl")
export Ctm, Ctime_t, Cclock_t

include("ngspice_common.jl")
include("ngspice_api.jl")

export BGThreadRunning, GetISRCData, GetSyncData, GetVSRCData, 
       SendChar, SendData, SendStat, SendInitData

foreach(names(@__MODULE__, all=true)) do s
    if startswith(string(s), "ng")
        @eval export $s
    end
end


end
