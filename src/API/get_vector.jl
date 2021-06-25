function get_vector_info(vecname, maxlen=Int(maxintfloat()))
    factor = 1.0
    if occursin("*", vecname)
        factor, vecname = split(vecname, "*")
        factor = parse(Float64, factor)
    end
    vec = ngGet_Vec_Info(vecname)
    vec != C_NULL || throw("Vector $(vecname) not found")
    vecinfo = unsafe_load(vec)
    vname  = unsafe_string(vecinfo.name)
    len = min(maxlen, vecinfo.length)
    typelist = Dict(0 => "notype",
                    1 => "time",
                    2 => "frequency",
                    3 => "voltage",
                    4 => "current",
                    5 => "voltage density",
                    6 => "current density",
                    7 => "sqr voltage density",
                    8 => "sqr current density",
                    9 => "sqr voltage",
                    10 => "sqr current",
                    11 => "pole",
                    12 => "zero",
                    13 => "sparam",
                    14 => "temp",
                    15 => "res",
                    16 => "impedence",
                    17 => "admittance",
                    18 => "power",
                    19 => "phase",
                    20 => "db",
                    21 => "capacitance",
                    22 => "charge",
                    )
    vtype = get(typelist, vecinfo.type, "-")
    if (vecinfo.flags & VF_REAL) != 0
        vreal = copy(unsafe_wrap(Array, vecinfo.realdata, (len,)))
        return vname, vtype, vreal*factor
    elseif (vecinfo.flags & VF_COMPLEX) != 0
        vcomplex = copy(unsafe_wrap(Array, vecinfo.compdata, (len,)))
        return vname, vtype, vcomplex*factor
    else
        error("Unknown vector type")
    end
end

function curplot()
    cur = ngSpice_CurPlot()
    cur != C_NULL || throw("No current plots")
    unsafe_string(cur)
end

function listallplots(nplots=Int(maxintfloat()))
    ppallplots = ngSpice_AllPlots()
    pallplots = unsafe_wrap(Array, ppallplots, nplots)
    allplots = String[]
    for pplot in pallplots
        pplot != C_NULL || return allplots
        plt = unsafe_string(pplot)
        push!(allplots, plt)
    end
end

function listcurvecs(plot=curplot(), nvecs=Int(maxintfloat()))
    ppcurvecs = ngSpice_AllVecs(plot)
    pcurvecs = unsafe_wrap(Array, ppcurvecs, nvecs)
    curvecs = String[]
    for pvec in pcurvecs
        pvec != C_NULL || return curvecs
        v = unsafe_string(pvec)
        push!(curvecs, v)
    end
end

function listallvecs(lplot=listallplots())
    allvecs = Dict(lplot .=> listcurvecs.(lplot))
    return allvecs      
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
