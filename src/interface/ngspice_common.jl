# Skipping MacroDefinition: IMPEXP __declspec ( dllimport )
using Dates

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
function std_print(text)
    occursin("stdout", text) && 
        (println(text[8:end]); return)
    (occursin("stderr", text) && !occursin("viewport", text)) &&
        (println(text[8:end]); return)
    occursin("viewport", text) && 
        (println("\nPlotting is skipped.\n")
                ; return)
    println(text)
end

function sendchar(_text::Ptr{Cchar}, id::Cint, userdata)::Cint
    _text != C_NULL || throw("Not a valid text")
    text = unsafe_string(_text)
    std_print(text)
    occursin(r"stderr Error:"i, text) && (ngerrorf = 1)
    return 0
end

gen_psendchar() = @cfunction(sendchar, Cint, (Ptr{Cchar}, Cint, Ptr{Cvoid}))

function sendstat(_text::Ptr{Cchar}, id::Cint, userdata)::Cint
    _text != C_NULL || throw("Not a valid text")
    text = unsafe_string(_text)
    std_print(text)
    return 0
end

gen_psendstat() = @cfunction(sendstat, Cint, (Ptr{Cchar}, Cint, Ptr{Cvoid}))

function bgthreadrunning(run::Cint, id::Cint, userdata::Ptr{Cvoid})::Cint
    bgrunning = run
    run ? println("BG thread is not running") :
        println("BG thread is running")
    return 0
end

gen_pbgthread() = @cfunction(bgthreadrunning, Cint, (Cint, Cint, Ptr{Cvoid}))

function controlledexit(exitstatus::Cint, immediate::Cint,
    quitexit::Cint, id::Cint, userdata::Ptr{Cvoid})::Cint
    quitexit == 1 && println("Returned from quit with exit status")
    immediate == 1 ? (println("Unloading NgSpice"); ngSpice_Command("quit")) :
        (println("Prepare an unload"); will_unload = 1)
    return exitstatus
end

gen_pcontrolledexit() = @cfunction(controlledexit, Cint, (Cint, Cint, Cint, Cint, Ptr{Cvoid}))

function senddata(vecdata::Ptr{vecinfoall},
    id::Cint, userdata::Ptr{Cvoid})::Cint
    return 0
end

gen_psenddata() = @cfunction(senddata, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid}))

function sendinitdata(initdata::Ptr{vecinfoall}, id::Cint, userdata::Ptr{Cvoid})
    #=
    This bit is problematic because it always returns C_NULLs even before
    `data.veccount` number of `vecinfo`s are passed.
    Even when that is handled it's o/p is always `nothing`
    and array of `nothing`s
    
    initdata == C_NULL && throw("No initialized data")
    data = unsafe_load(initdata)
    vec = unsafe_wrap(Array, data.vecs, (data.veccount, ))
    for v in vec
        v.name == C_NULL && return zero(Int32)
        vname = unsafe_string(v.name)
        vpdvec = unsafe_wrap(Array, v.pdvec, 10)
        vpdscale = unsafe_wrap(Array, v.pdvecscale, 10)
        println(vname, vpdscale, vpdvec)
    end
    =#
    return zero(Int32)
end

gen_psendinitdata() = @cfunction(sendinitdata, Cint, (Ptr{vecinfoall}, Cint, Ptr{Cvoid}))
