
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
const pvecinfoall = Ptr{vecinfoall}

