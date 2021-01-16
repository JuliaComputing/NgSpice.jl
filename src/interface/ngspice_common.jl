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

struct vector_info
    name::Cstring
    type::Cint
    flags::Int16
    realdata::Ptr{Cdouble}
    compdata::Ptr{ngcomplex_t}
    length::Cint
end

const pvector_info = Ptr{vector_info}

struct vecvalues
    name::Cstring
    creal::Cdouble
    cimag::Cdouble
    is_scale::Cint
    is_complex::Cint
end

const pvecvalues = Ptr{vecvalues}

struct vecvaluesall
    veccount::Cint
    vecindex::Cint
    vecsa::Ptr{pvecvalues}
end

const pvecvaluesall = Ptr{vecvaluesall}

struct vecinfo
    number::Cint
    name::Cstring
    is_real::Cint
    pdvec::Ptr{Cvoid}
    pdvecscale::Ptr{Cvoid}
end

const pvecinfo = Ptr{vecinfo}

struct vecinfoall
    name::Cstring
    title::Cstring
    date::Cstring
    type::Cstring
    veccount::Cint
    vecs::Ptr{pvecinfo}
end

const pvecinfoall = Ptr{vecinfoall}

ngerror, bgrunning, vecgetnum = 0, 0, 0

function sendchar(_text::Ptr{Cchar}, id::Int32, userdata)::Cint
    _text != C_NULL || throw("Not a valid text")
    text = unsafe_string(_text)
    println("SPICE STATUS : $text" )
    occursin(r"stderr Error:"i, text) && (ngerror = 1)
    return 0
end

gen_sendcharptr() = @cfunction($sendchar, Cint, (Ptr{Cchar}, Cint, Ptr{Cvoid}))
sendcharptr       = gen_sendcharptr()

function sendstat(_text::Ptr{Cchar}, id::Int32, userdata)::Cint
    _text != C_NULL || throw("Not a valid text")
    text = unsafe_string(_text)
    println("SPICE STATUS : $text" )
    return 0
end

gen_sendstatptr() = @cfunction($sendstat, Cint, (Ptr{Cchar}, Cint, Ptr{Cvoid}))
sendstatptr       = gen_sendstatptr()

function bgthreadrunning(run::Cint, id::Cint, userdata::Ptr{Cvoid})::Cint
    bgrunning = run
    run ? println("BG thread is not running") : 
        println("BG thread is running")
    return 0
end

gen_bgthreadptr() = @cfunction($bgthreadrunning, Cint, (Cint, Cint, Ptr{Cvoid}))
bgthreadptr       = gen_bgthreadptr()

function controlledexit(exitstatus::Cint, immediate::Cint, 
    quitexit::Cint, id::Cint, userdata::Ptr{Cvoid})::Cint
    quitexit && println("Returned from quit with exit status")
    immediate ? (println("Unloading Ngspice"); ngSpice_Command("quit")) :
        (println("Prepare an unload"); will_unload = 1)
    return exitstatus
end

get_controlledexitptr() = @cfunction($controlledexit, Cint, (Cint, Cint, Cint, Cint, Ptr{Cvoid}))
controlledexitptr       = get_controlledexitptr() 


function senddata(vecdata::Ptr{vecvaluesall}, novecs::Cint, 
    id::Cint, userdata::Ptr{Cvoid})::Cint
    ##TBD
    #=v2dat = vecdata.vecsa[vecgetnum].creal
    if !hasbreak && v2dat > 0.5
        send SIGTERM and run alterp from main thread on Windows machines
    =#
    return 0
end

get_senddataptr = @cfunction($sendinitdata, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid}))
senddataptr     = get_senddataptr() 

function sendinitdata(initdata::Ptr{vecinfoall}, id::Cint, userdata::Ptr{Cvoid})
    for i in range(1, stop=initdata.veccount)
        println("Vector: $(initdata.vecs[i].name)")
        occursin(r"V(2)"i, initdata.vecs[i].name) && (vecgetnum = i)
    end
    return 0
end

get_sendinitdataptr = @cfunction($sendinitdata, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid}))
sendinitdataptr     = get_sendinitdataptr() 

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
SendChar_wrapper(f) = @cfunction($f, Cint, (Ptr{Char}, Cint, Ptr{Cvoid})).ptr

SendStat_wrapper(fp::Ptr{Cvoid}) = fp
SendStat_wrapper(f) = @cfunction($f, Cint, (Ptr{Char}, Cint, Ptr{Cvoid})).ptr

ContolledExit_wrapper(fp::Ptr{Cvoid}) = fp
ContolledExit_wrapper(f) = @cfunction($f, Cint, (Cint, Cint, Cint, Cint, Ptr{Cvoid})).ptr

SendData_wrapper(fp::Ptr{Cvoid}) = fp
SendData_wrapper(f) = @cfunction($f, Cint, (Ptr{vecvaluesall}, Cint, Cint, Ptr{Cvoid})).ptr

SendInitData_wrapper(fp::Ptr{Cvoid}) = fp
SendInitData_wrapper(f) = @cfunction($f, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid})).ptr

BGThreadRunning_wrapper(fp::Ptr{Cvoid}) = fp
BGThreadRunning_wrapper(f) = @cfunction($f, Cint, (Cint, Cint, Ptr{Cvoid})).ptr

GetVSRCData_wrapper(fp::Ptr{Cvoid}) = fp
GetVSRCData_wrapper(f) = @cfunction($f, Cint, (Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid})).ptr


GetISRCData_wrapper(fp::Ptr{Cvoid}) = fp
GetISRCData_wrapper(f) = @cfunction($f, Cint, (Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid})).ptr


GetSyncData_wrapper(fp::Ptr{Cvoid}) = fp
GetSyncData_wrapper(f) = @cfunction($f, Cint, (Cdouble, Ptr{Cdouble}, Cdouble, Cint, Cint, Cint, Ptr{Cvoid})).ptr
=#
