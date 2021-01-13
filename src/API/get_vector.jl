function get_vector(vecname)
    vec  = n.ngGet_Vec_Info(vecname)
    vec != convert(Ptr{Nothing}, 0) || throw("Points to null")
    vname  = unsafe_load(convert(Ptr{UInt8}, vec.name))
    vreal  = unsafe_load(vec.realdata)
    _cmp = unsafe_load(vec.compdata)
    vcmplx = Complex(_cmp.real, _cmp.imag)
    return vname, vreal, vcmplx
end

#=
th = get_vector("n3")
th[3]
fr = get_vector("frequency")
using Plots
plot(th(2), fr(2))
a = dump(vecinf)
unsafe_load(vecinf.realdata)
unsafe_load(vecinf.compdata)
unsafe_load(vecinf.type)
for i in range(1, stop = vecinf.length)
    println(unsafe_load(vecinf.realdata)[i])
end

unsafe_string(Ptr{UInt8}[vecinf.name][1])
n._command(:C_NULL)
n.reset()
n.halt()=#