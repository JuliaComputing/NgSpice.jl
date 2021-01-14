function get_vector(vecname)
    vec = ngGet_Vec_Info(vecname)
    vec != C_NULL || throw("Vector $(vecname) not found")
    vecinfo = unsafe_load(vec)
    vname  = unsafe_string(vecinfo.name)
    if (vecinfo.flags & VF_REAL) != 0
        vreal = copy(unsafe_wrap(Array, vecinfo.realdata, (vecinfo.length,)))
        return vname, vreal
    elseif (vecinfo.flags & VF_COMPLEX) != 0
        vcomplex = copy(unsafe_wrap(Array, vecinfo.realdata, (vecinfo.length,)))
        return vname, vcmplx
    else
        error("Unknown vector type")
    end
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
