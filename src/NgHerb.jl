module NgHerb

using ngspice_jll
export ngspice_jll

include("interface/ngspice_common.jl")
include("interface/signals.jl")
include("interface/callbacks.jl")
include("interface/ngspice_api.jl")
include("API/running.jl")
include("API/sim_utils.jl")
include("API/get_vector.jl")

# Callback pointers (must be created at run time, in __init__)
const gen_psendchar       = Ref{Ptr{Cvoid}}(C_NULL)
const gen_pcontrolledexit = Ref{Ptr{Cvoid}}(C_NULL)

function __init__()
    gen_psendchar[]       = @cfunction(sendchar,       Cint, (Ptr{Cchar}, Cint, Ptr{Cvoid}))
    gen_pcontrolledexit[] = @cfunction(controlledexit, Cint, (Cint, Cint, Cint, Cint, Ptr{Cvoid}))
    init()
end

be_quiet()   = (quiet[] = true;  nothing)
be_verbose() = (quiet[] = false; nothing)
const dump_buffer = dumpbuffer

#================ Special Strings =====================#
# These expand to *calls*, so they run every time the surrounding code runs
# (previously the call happened once, at macro-expansion time, and its result
# was pasted into the code as a constant).

# ng"" sends the quoted command to the simulator
macro ng_str(s)
    :($cmd($s))
end

# real"" retrieves the real-valued part of the indicated vector
macro real_str(s)
    :($getrealvec($s))
end

# imag"" retrieves the imaginary-valued part of the indicated vector
macro imag_str(s)
    :($getimagvec($s))
end

# i"" retrieves the current in the indicated voltage source
macro i_str(s)
    :($getrealvec($(s * "#branch")))
end

# magnitude"" retrieves the complex magnitude of the indicated vector
macro magnitude_str(s)
    :($getmagnitudevec($s))
end

# dB"" retrieves a magnitude vector and converts to dB20
macro dB_str(s)
    :(20.0 .* log10.($getmagnitudevec($s)))
end

# phase"" retrieves a phase vector and converts to degrees
macro phase_str(s)
    :((180 / π) .* $getphasevec($s))
end

# vec"" returns a vector, possibly complex
macro vec_str(s)
    :($getvec($s))
end

export @ng_str, @real_str, @imag_str, @i_str, @magnitude_str, @dB_str, @phase_str, @vec_str
export dumpbuffer, dump_buffer, be_quiet, be_verbose

end
