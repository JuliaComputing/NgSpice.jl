function get_vector_info(vecname, maxlen=Int(maxintfloat()))
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

curplot() = ngSpice_CurPlot()

function allvecs()
    curplot = ngSpice_CurPlot();
    curplot != C_NULL || throw("No current plots")
    allplots = ngSpice_AllVecs(curplot)
    ret = []
    plot = allplots
    while plot != C_NULL
        ret = [ret; unsafe_string(unsafe_load(plot))] #see if this is efficient
        plot += 1
    end
    return ret
end #revisit

function getvec(name, maxlen=Int(maxintfloat()))
    get_vector_info(name, maxlen) 
end

function getrealvec(name, maxlen=Int(maxintfloat()))
    _, data = get_vector_info(name, maxlen)
    real(data)
end

function getimagvec(name, maxlen=Int(maxintfloat()))
    _, data = get_vector_info(name, maxlen)
    imag(data)
end

function getmagnitudevec(name, maxlen=Int(maxintfloat()))
    _, data = get_vector_info(name, maxlen)
    abs.(data)
end

function getphasevec(name, maxlen=Int(maxintfloat))
    _, data = get_vector_info(name, maxlen)
    angle.(data)
end
