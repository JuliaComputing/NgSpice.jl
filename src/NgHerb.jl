__precompile__()
module NgHerb

using ngspice_jll
export ngspice_jll

using DataStructures

include("interface/ngspice_common.jl")
include("interface/callbacks.jl")
include("interface/ngspice_api.jl")
include("API/sim_utils.jl")
include("API/running.jl")
include("API/get_vector.jl")

#const async_cond    = Ref{Base.AsyncCondition}()
string_buffer       = CircularBuffer{UInt8}(10000)

# Callback pointers
const gen_psendchar       = Ref{Ptr{Cvoid}}(C_NULL)
const gen_pcontrolledexit = Ref{Ptr{Cvoid}}(C_NULL)

const     gen_psendstat      = Ref{Ptr{Cvoid}}(C_NULL)
const     gen_pbgthread      = Ref{Ptr{Cvoid}}(C_NULL)
const     gen_psenddata      = Ref{Ptr{Cvoid}}(C_NULL)
const     gen_psendinitdata  = Ref{Ptr{Cvoid}}(C_NULL)
    
pcbvec = Vector{Ref}()
cbvec  = Vector{Function}()

data_pointer = Ptr{vecinfoall}(0)

function __init__()
    
    #async_cond[] = Base.AsyncCondition()

    # We will just need these callbacks:
    gen_psendchar[]       = @cfunction(sendchar,       Cint, (Ptr{Cchar}, Cint, Ptr{Cvoid}                   ))
    gen_pcontrolledexit[] = @cfunction(controlledexit, Cint, (Cint,       Cint, Cint,        Cint, Ptr{Cvoid}))
    
    for x in (gen_psendchar, gen_pcontrolledexit)
        push!(pcbvec,x)
    end

    for x in (sendchar,controlledexit)
        push!(cbvec,x)
    end

    init()

    sleep(0.1)
    dumpbuffer()
end



function callback_listener()
    @async begin
        try
            while isopen(async_cond[])
                GC.enable(true)
                GC.gc()
                GC.enable(false)

                wait(async_cond[])
                
                # Dump contents from ring buffer
                buf_str = String(collect(string_buffer))
                empty!(string_buffer)

                # Remove "stdout " from start of lines
                io=IOBuffer()
                for l in eachsplit(buf_str,"\n")
                    println(io,replace(l,r"^stdout "=>""))
                end

                # Print everything
                println(String(take!(seekstart(io))))

                
            end
        catch err
            @error "Error in AsyncCondition processing loop" exception=(err, catch_backtrace())
        end
    end
end


function dumpbuffer()
    try
        # Dump contents from ring buffer
        buf_str = String(collect(string_buffer))
        empty!(string_buffer)
        
        # Remove "stdout " from start of lines
        io=IOBuffer()
        for l in eachsplit(buf_str,"\n")
            println(io,replace(l,r"^stdout "=>""))
        end
        
        # Print everything
        println(String(take!(seekstart(io))))
    catch err
        @error "Error in AsyncCondition processing loop" exception=(err, catch_backtrace())
    end
end


#================ Special Strings =====================#
# ng"" sends the quoted command to the simulator
macro ng_str(s)
    NgHerb.cmd(s)    
end

# real"" retrieves the real-valued part of the indicated vector
macro real_str(s)
    NgHerb.getrealvec(s)
end

# imag"" retrieves the imaginary-valued part of the indicated vector
macro imag_str(s)
    NgHerb.getimaginaryvec(s)
end

# i"" retrieves the current in the indicated voltage source
macro i_str(s)
    NgHerb.getrealvec(s*"#branch")
end

# magnitude"" retrieves the complex magnitude of the indicated vector
macro magnitude_str(s)
    NgHerb.getmagnitudevec(s)
end

# dB"" retrieves a magnitude vector and converts to dB20
macro dB_str(s)
    20.0 .* log10.(NgHerb.getmagnitudevec(s))
end

# phase"" retrieves a phase vector and converts to degrees
macro phase_str(s)
    (180/π).*NgHerb.getphasevec(s)
end

# vec"" returns a vector, possibly complex 
macro vec_str(s)
    NgHerb.getvec(s)
end




export @ng_str, @real_str, @imag_str, @i_str, @magnitude_str, @dB_str, @phase_str, @vec_str

end
