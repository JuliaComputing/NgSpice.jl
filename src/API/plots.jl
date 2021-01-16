#plots mean vectors or group of vectors

curplot() = ngSpice_CurPlot()

function allplots()
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
end

function getplot(name, maxlen::Int)
    get_vector_info(name, maxlen) 
end

function getrealplot(name, maxlen::Int)
    _, data = get_vector_info(name, maxlen)
    real(data)
end

function getimagplot(name, maxlen::Int)
    _, data = get_vector_info(name, maxlen)
    imag(data)
end

function getmagnitudeplot(name, maxlen::Int)
    _, data = get_vector_info(name, maxlen)
    abs(data)
end

function getphaseplot(name, maxlen::Int)
    _, data = get_vector_info(name, maxlen)
    angle(data)
end









