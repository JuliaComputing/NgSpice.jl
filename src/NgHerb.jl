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

const async_cond    = Ref{Base.AsyncCondition}()
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
    
    async_cond[] = Base.AsyncCondition()

    # We will just need these callbacks:
    gen_psendchar[]       = @cfunction(sendchar,       Cint, (Ptr{Cchar}, Cint, Ptr{Cvoid}                   ))
    gen_pcontrolledexit[] = @cfunction(controlledexit, Cint, (Cint,       Cint, Cint,        Cint, Ptr{Cvoid}))
    
    for x in (gen_psendchar, gen_pcontrolledexit)
        push!(pcbvec,x)
    end

    for x in (sendchar,controlledexit)
        push!(cbvec,x)
    end

    # Asynchronous wait loop for ngspice library messages
    @async begin
        try
            while isopen(async_cond[])
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
    init()
end

end
