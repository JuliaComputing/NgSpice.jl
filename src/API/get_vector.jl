function get_vector_info(vecname, maxlen=Inf)
    vec = ngGet_Vec_Info(vecname)
    vec != C_NULL || throw("Vector $(vecname) not found")
    vecinfo = unsafe_load(vec)
    vname  = unsafe_string(vecinfo.name)
    len = min(maxlen, vecinfo.length)
    if (vecinfo.flags & VF_REAL) != 0
        vreal = copy(unsafe_wrap(Array, vecinfo.realdata, (len,)))
        return vname, vreal
    elseif (vecinfo.flags & VF_COMPLEX) != 0
        vcomplex = copy(unsafe_wrap(Array, vecinfo.compdata, (len,)))
        return vname, vcomplex
    else
        error("Unknown vector type")
    end
end
