const VECTOR_TYPES = Dict(0 => "notype", 1 => "time", 2 => "frequency",
    3 => "voltage", 4 => "current", 5 => "voltage density", 6 => "current density",
    7 => "sqr voltage density", 8 => "sqr current density", 9 => "sqr voltage",
    10 => "sqr current", 11 => "pole", 12 => "zero", 13 => "sparam", 14 => "temp",
    15 => "res", 16 => "impedence", 17 => "admittance", 18 => "power", 19 => "phase",
    20 => "db", 21 => "capacitance", 22 => "charge")

function get_vector_info(vecname, maxlen=typemax(Int))
    factor = 1.0
    if occursin("*", vecname)
        f, vecname = split(vecname, "*")
        factor = parse(Float64, f)
    end
    # Read the vector and copy its data out while holding the lock: the pointers
    # in VectorInfo belong to ngspice and are invalidated by the next command.
    r = ngcall() do
        vec = ngGet_Vec_Info(String(vecname))
        vec == C_NULL && return nothing
        vecinfo = unsafe_load(vec)
        len = min(maxlen, Int(vecinfo.length))
        if (vecinfo.flags & VF_REAL) != 0
            d = copy(unsafe_wrap(Array, vecinfo.realdata, (len,)))
        elseif (vecinfo.flags & VF_COMPLEX) != 0
            d = copy(unsafe_wrap(Array, vecinfo.compdata, (len,)))
        else
            d = nothing
        end
        (unsafe_string(vecinfo.name), get(VECTOR_TYPES, Int(vecinfo.type), "-"), d)
    end
    r === nothing && error("Vector $(vecname) not found")
    vname, vtype, data = r
    data === nothing && error("Unknown vector type for $(vname)")
    return vname, vtype, data * factor
end

function curplot()
    name = ngcall() do
        cur = ngSpice_CurPlot()
        cur == C_NULL ? nothing : unsafe_string(cur)
    end
    name === nothing && error("No current plots")
    return name
end

# Copy a NULL-terminated char** owned by ngspice into Julia strings.
function cstring_list(pp::Ptr{Ptr{UInt8}}, limit=typemax(Int))
    out = String[]
    pp == C_NULL && return out
    i = 1
    while i <= limit
        p = unsafe_load(pp, i)
        p == C_NULL && break
        push!(out, unsafe_string(p))
        i += 1
    end
    return out
end

listallplots(nplots=typemax(Int)) = ngcall(() -> cstring_list(ngSpice_AllPlots(), nplots))

listcurvecs(plot=curplot(), nvecs=typemax(Int)) =
    ngcall(() -> cstring_list(ngSpice_AllVecs(plot), nvecs))

function listallvecs(lplot=listallplots())
    return Dict(lplot .=> listcurvecs.(lplot))
end

getvec(name, maxlen=typemax(Int)) = get_vector_info(name, maxlen)

function getrealvec(name, maxlen=typemax(Int))
    _, __, data = get_vector_info(String(name), maxlen)
    real(data)
end

function getimagvec(name, maxlen=typemax(Int))
    _, __, data = get_vector_info(name, maxlen)
    imag(data)
end

function getmagnitudevec(name, maxlen=typemax(Int))
    _, __, data = get_vector_info(name, maxlen)
    abs.(data)
end

function getphasevec(name, maxlen=typemax(Int))
    _, __, data = get_vector_info(name, maxlen)
    angle.(data)
end
