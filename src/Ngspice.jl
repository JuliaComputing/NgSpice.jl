__precompile__()
module Ngspice

using ngspice_jll
export ngspice_jll

include("interface/ctypes.jl")
export Ctm, Ctime_t, Cclock_t

include("interface/ngspice_common.jl")
include("interface/ngspice_api.jl")

#= Might not be necessary
export bgthreadrunning, controlledexit, #getISRCdata, detsyncdata, getVSRCdata, 
       sendchar, senddata, sendstat, sendinitdata=#

export gen_pbgthread, gen_pcontrolledexit, gen_psendchar, gen_psenddata,
       gen_psendinitdata, gen_psendstat, 
       pbgthread, pcontrolledexit, psendchar, psenddata, psendinitdata,
       psendstat

foreach(names(@__MODULE__, all=true)) do s
    if startswith(string(s), "ng")
        @eval export $s
    end
end #should this be replaced with aliases

include("API/get_vector.jl")
include("API/netlist.jl")
include("API/plots.jl")
include("API/running.jl")

export get_vector_info, load_netlist,
       bghalt, bgrun, cmd, init, isrunning, reset, simhalt, simrun, 
       allplots, curplot, getimagplot, getmagnitudeplot,
       getphaseplot, getplot, getrealplot

end


