function get_vector_info(vecname, maxlen=Int(maxintfloat()))
    vec = ngGet_Vec_Info(vecname)
    vec != C_NULL || throw("Vector $(vecname) not found")
    vecinfo = unsafe_load(vec)
    vname  = unsafe_string(vecinfo.name)
    len = min(maxlen, vecinfo.length)
    typelist = ["time", "frequency", "current", "voltage"]
    vtype = typelist[vecinfo.type]
    if (vecinfo.flags & VF_REAL) != 0
        vreal = copy(unsafe_wrap(Array, vecinfo.realdata, (len,)))
        return vname, vtype, vreal
    elseif (vecinfo.flags & VF_COMPLEX) != 0
        vcomplex = copy(unsafe_wrap(Array, vecinfo.compdata, (len,)))
        return vname, vtype, vcomplex
    else
        error("Unknown vector type")
    end
end

function curplot()
    cur = ngSpice_CurPlot()
    cur != C_NULL || throw("No current plots")
    unsafe_string(cur)
end

function listallvecs(novecs=Int(maxintfloat()))
    curplot = NgSpice.curplot()
    curplot != C_NULL || throw("No current plots")
    ppallplots = ngSpice_AllVecs(curplot)
    pallplots = unsafe_wrap(Array, ppallplots, novecs)
    allplots = []
    for pplot in pallplots
        pplot != C_NULL || return allplots
        plt = unsafe_string(pplot)
        push!(allplots, plt)
    end
end 

function getvec(name, maxlen=Int(maxintfloat()))
    get_vector_info(name, maxlen) 
end

function getrealvec(name, maxlen=Int(maxintfloat()))
    _, __, data = get_vector_info(String(name), maxlen)
    real(data)
end

function getimagvec(name, maxlen=Int(maxintfloat()))
    _, __, data = get_vector_info(name, maxlen)
    imag(data)
end

function getmagnitudevec(name, maxlen=Int(maxintfloat()))
    _, __, data = get_vector_info(name, maxlen)
    abs.(data)
end

function getphasevec(name, maxlen=Int(maxintfloat))
    _, __, data = get_vector_info(name, maxlen)
    angle.(data)
end
