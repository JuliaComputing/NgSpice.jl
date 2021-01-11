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
=#

const SendChar = Cvoid
const SendStat = Cvoid
const ControlledExit  = Cvoid
const SendData     = Cvoid
const SendInitData = Cvoid
const BGThreadRunning = Cvoid
const GetVSRCData  = Cvoid
const GetISRCData  = Cvoid
const GetSyncData = Cvoid

const FnTypeSignatures = Dict(
    :SendChar     => (:Cint, :((Ptr{Char}, Cint, Ptr{Cvoid}))),
    :SendStat     => (:Cint, :((Ptr{Char}, Cint, Ptr{Cvoid}))),
    :ControlledExit  => (:Cint, :((Cint, Cint, Cint, Cint, Ptr{Cvoid}))),
    :SendData     => (:Cint, :((Ptr{vecvaluesall}, Cint, Cint, Ptr{Cvoid}))),
    :SendInitData => (:Cint, :((Ptr{vecinfoall}, Cint, Ptr{Cvoid}))),
    :BGThreadRunning => (:Cint, :((Cint, Cint, Ptr{Cvoid}))),
    :GetVSRCData  => (:Cint, :((Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid}))),
    :GetISRCData  => (:Cint, :((Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid}))),
    :GetSyncData  => (:Cint, :((Cdouble, Ptr{Cdouble}, Cdouble, Cint, Cint, Cint, Ptr{Cvoid})))
)

SendChar_wrapper(fp::SendChar) = fp
SendChar_wrapper(f) = @cfunction($f, Cint, (Ptr{Char}, Cint, Ptr{Cvoid})).ptr

SendStat_wrapper(fp::SendStat) = fp
SendStat_wrapper(f) = @cfunction($f, Cint, (Ptr{Char}, Cint, Ptr{Cvoid})).ptr

ContolledExit_wrapper(fp::ControlledExit) = fp
ContolledExit_wrapper(f) = @cfunction($f, Cint, (Cint, Cint, Cint, Cint, Ptr{Cvoid})).ptr

SendData_wrapper(fp::SendData) = fp
SendData_wrapper(f) = @cfunction($f, Cint, (Ptr{vecvaluesall}, Cint, Cint, Ptr{Cvoid})).ptr

SendInitData_wrapper(fp::SendInitData) = fp
SendInitData_wrapper(f) = @cfunction($f, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid})).ptr

BGThreadRunning_wrapper(fp::BGThreadRunning) = fp
BGThreadRunning_wrapper(f) = @cfunction($f, Cint, (Cint, Cint, Ptr{Cvoid})).ptr

GetVSRCData_wrapper(fp::GetVSRCData) = fp
GetVSRCData_wrapper(f) = @cfunction($f, Cint, (Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid})).ptr


GetISRCData_wrapper(fp::GetISRCData) = fp
GetISRCData_wrapper(f) = @cfunction($f, Cint, (Ptr{Cdouble}, Cdouble, Ptr{Cchar}, Cint, Ptr{Cvoid})).ptr


GetSyncData_wrapper(fp::GetSyncData) = fp
GetSyncData_wrapper(f) = @cfunction($f, Cint, (Cdouble, Ptr{Cdouble}, Cdouble, Cint, Cint, Cint, Ptr{Cvoid})).ptr
