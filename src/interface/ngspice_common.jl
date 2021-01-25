# Skipping MacroDefinition: IMPEXP __declspec ( dllimport )
const ngcomplex_t = Complex{Cdouble}

const VF_REAL = (1 << 0)
const VF_COMPLEX = (1 << 1)
const VF_ACCUM = (1 << 2)
const VF_PLOT = (1 << 3)
const VF_PRINT = (1 << 4)
const VF_MINGIVEN = (1 << 5)
const VF_MAXGIVEN = (1 << 6)
const VF_PERMANENT = (1 << 7)

"""
 Vector info obtained from any vector in ngspice.dll.
 Allows direct access to the ngspice internal vector structure,
 as defined in include/ngspice/devc.h .
"""
struct vector_info
    name::Cstring              # Same as so_vname
    type::Cint 	               # Same as so_vtype
    flags::Int16               # Flags (a combination of VF_*)
    realdata::Ptr{Cdouble}     # Real data
    compdata::Ptr{ngcomplex_t} # Complex data.
    length::Cint               # Length of the vector
end

const pvector_info = Ptr{vector_info}

struct vecvalues
    name::Cstring              # name of a specific vector 
    creal::Cdouble             # actual data value
    cimag::Cdouble             # actual data value
    is_scale::Cint             # if 'name' is the scale vector
    is_complex::Cint           # if the data are complex numbers
end

const pvecvalues = Ptr{vecvalues}

struct vecvaluesall
    veccount::Cint         # number of vectors in plot
    vecindex::Cint         # index of actual set of vectors. i.e. the number of accepted data point
    vecsa::pvecvalues # values of actual set of vectors, indexed from 0 to veccount - 1 
        #just pvecvalues?
end

const pvecvaluesall = Ptr{vecvaluesall}
struct vecinfo              
    number::Cint           # number of vector, as postion in the linked list of vectors, s
    name::Cstring          # name of the actual vector 
    is_real::Cint          # 1 if the actual vector has real data
    pdvec::Ptr{Cvoid}      # a void pointer to struct dvec *d, the actual vector
    pdvecscale::Ptr{Cvoid} # a void pointer to struct dvec *ds, the scale vector

end

const pvecinfo = Ptr{vecinfo}

struct vecinfoall
    name::Cstring
    title::Cstring
    date::Cstring
    type::Cstring
    veccount::Cint
    vecs::pvecinfo 
end

#const pvecinfoall = Ptr{vecinfoall}

ngerrorf, bgrunningf, vecgetnum = 0, 0, 0

function sendchar(_text::Ptr{Cchar}, id::Cint, userdata)::Cint
    _text != C_NULL || throw("Not a valid text")
    text = unsafe_string(_text)
    println(text)
    occursin(r"stderr Error:"i, text) && (ngerrorf = 1)
    return 0
end

gen_psendchar() = @cfunction($sendchar, Cint, (Ptr{Cchar}, Cint, Ptr{Cvoid}))
psendchar       = gen_psendchar()

function sendstat(_text::Ptr{Cchar}, id::Cint, userdata)::Cint
    _text != C_NULL || throw("Not a valid text")
    text = unsafe_string(_text)
    println(text)
    return 0
end

gen_psendstat() = @cfunction($sendstat, Cint, (Ptr{Cchar}, Cint, Ptr{Cvoid}))
psendstat       = gen_psendstat()

function bgthreadrunning(run::Cint, id::Cint, userdata::Ptr{Cvoid})::Cint
    bgrunning = run
    run ? println("BG thread is not running") : 
        println("BG thread is running")
    return 0
end

gen_pbgthread() = @cfunction($bgthreadrunning, Cint, (Cint, Cint, Ptr{Cvoid}))
pbgthread       = gen_pbgthread()

function controlledexit(exitstatus::Cint, immediate::Cint, 
    quitexit::Cint, id::Cint, userdata::Ptr{Cvoid})::Cint
    quitexit && println("Returned from quit with exit status")
    immediate ? (println("Unloading NgSpice"); ngSpice_Command("quit")) :
        (println("Prepare an unload"); will_unload = 1)
    return exitstatus
end

gen_pcontrolledexit() = @cfunction($controlledexit, Cint, (Cint, Cint, Cint, Cint, Ptr{Cvoid}))
pcontrolledexit       = gen_pcontrolledexit() 

function senddata(vecdata::Ptr{vecvaluesall}, novecs::Cint, 
    id::Cint, userdata::Ptr{Cvoid})::Cint
    allvecdata = []
    for i in range(0, stop=novecs)
        append!(allvecdata, unsafe_load(vecdata.vecsa))
    end
    #println(allvecdata)
    return 0
end

gen_psenddata() = @cfunction($senddata, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid}))
psenddata       = gen_psenddata() 

function sendinitdata(initdata::Ptr{vecinfoall}, id::Cint, userdata::Ptr{Cvoid})
    initdata == C_NULL && throw("No initialized data")
    data = unsafe_load(initdata)
    vec = unsafe_wrap(Array, data.vecs, (data.veccount, ))
    #println("-----SendInit-------")
    for v in vec
        v.name == C_NULL && return 0
        println("Vector: $(unsafe_string(v.name))")
    end
    return 0
end

gen_psendinitdata() = @cfunction($sendinitdata, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid}))
psendinitdata       = gen_psendinitdata() 

#### TBD: Do we still need these `_wrappers` and `FnTypeSignatures`?
#=const FnTypeSignatures = Dict(
    :SendChar        => (:Cint, :((Ptr{Char}, Cint, Ptr{Cvoid}))),
    :SendStat        => (:Cint, :((Ptr{Char}, Cint, Ptr{Cvoid}))),
    :ControlledExit  => (:Cint, :((Cint, Cint, Cint, Cint, Ptr{Cvoid}))),
    :SendData        => (:Cint, :((Ptr{vecvaluesall}, Cint, Cint, Ptr{Cvoid}))),
    :SendInitData    => (:Cint, :((Ptr{vecinfoall}, Cint, Ptr{Cvoid}))),
    :BGThreadRunning => (:Cint, :((Cint, Cint, Ptr{Cvoid}))),
    :GetVSRCData     => (:Cint, :((Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid}))),
    :GetISRCData     => (:Cint, :((Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid}))),
    :GetSyncData     => (:Cint, :((Cdouble, Ptr{Cdouble}, Cdouble, Cint, Cint, Cint, Ptr{Cvoid})))
)

SendChar_wrapper(fp::Ptr{Cvoid}) = fp
SendStat_wrapper(fp::Ptr{Cvoid}) = fp
ContolledExit_wrapper(fp::Ptr{Cvoid}) = fp
SendData_wrapper(fp::Ptr{Cvoid}) = fp
SendInitData_wrapper(fp::Ptr{Cvoid}) = fp
BGThreadRunning_wrapper(fp::Ptr{Cvoid}) = fp
=#

#### TBD
#=GetVSRCData_wrapper(fp::Ptr{Cvoid}) = fp
GetVSRCData_wrapper(f) = @cfunction($f, Cint, (Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid})).ptr


GetISRCData_wrapper(fp::Ptr{Cvoid}) = fp
GetISRCData_wrapper(f) = @cfunction($f, Cint, (Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid})).ptr


GetSyncData_wrapper(fp::Ptr{Cvoid}) = fp
GetSyncData_wrapper(f) = @cfunction($f, Cint, (Cdouble, Ptr{Cdouble}, Cdouble, Cint, Cint, Cint, Ptr{Cvoid})).ptr
=#
