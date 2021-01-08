# Skipping MacroDefinition: IMPEXP __declspec ( dllimport )
struct ngcomplex
    cx_real::Cdouble
    cx_imag::Cdouble
end

const ngcomplex_t = ngcomplex

struct vector_info
    v_name::Cstring
    v_type::Cint
    v_flags::Int16
    v_realdata::Ptr{Cdouble}
    v_compdata::Ptr{ngcomplex_t}
    v_length::Cint
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
    vecname::Cstring
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

const BGThreadRunning = Cvoid

#=Function pointers skipped by the generator

SendChar       typedef of callback function for reading printf, fprintf, fputs
SendStat       typedef of callback function for reading status string and precent value
ControlledExit typedef of callback function for tranferring a signal upon
               ngspice controlled_exit to caller. May be used by caller
               to detach ngspice.dll.
SendData       typedef of callback function for sending an array of structs containing
               data values of all vectors in the current plot (simulation output)
SendInitData   typedef of callback function for sending an array of structs containing info on
               all vectors in the current plot (immediately before simulation starts)
BGThreadRunning typedef of callback function for sending a boolean signal (true if thread
                is running)

# SendStat "points to function ∈ ["agauss", "gauss", "aunif", "unif", "limit"]

#TODO Function definitions
function sendchar(Ptr{Cchar}, Cint, Ptr{Cvoid})::Cint end
SendChar = @cfunction(sendchar, Cint, (Ptr{Char}, Cint, Ptr{Cvoid}))

function sendstat(Ptr{Cchar}, Cint, Ptr{Cvoid})::Cint end
SendStat = @cfunction(sendstat, Cint, (Ptr{Char}, Cint, Ptr{Cvoid}))

function controlledexit(Cint, Cint, Cint, Cint, Ptr{Cvoid}):Cint end
ControlledExit = @cfunction(controlledexit, Cint, (Cint, Cint, Cint, Cint, Ptr{Cvoid}))

function senddata(Ptr{vecvaluesall}, Cint, Cint, Ptr{Cvoid})::Cint end
SendData = @cfunction(senddata, Cint, (Ptr{vecvaluesall}, Cint, Cint, Ptr{Cvoid}))

function sendinitdata(sendinitdata, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid})::Cint end
SendInitData = @cfunction(sendinitdata, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid}))

function getvsrcdata(Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid})::Cint end
GetVSRCData = @cfunction(getvsrcdata, Cint, (Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid}))

function getisrcdata(Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid})::Cint end
GetISRCData = @cfunction(getisrcdata, Cint, (Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid}))

function getsyncdata(Cdouble, Ptr{Cdouble}, Cdouble, Cint, Cint, Cint, Ptr{Cvoid})::Cint end
GetSyncData = @cfunction(getsyncdata, Cint, (Cdouble, Ptr{Cdouble}, Cdouble, Cint, Cint, Cint, Ptr{Cvoid}))
=#