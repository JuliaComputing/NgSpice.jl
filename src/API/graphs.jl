using RecipesBase
using Colors
using .Plots

struct NgSpiceGraphs end

const graph = NgSpiceGraphs()

# `fort` is frequency or time vector. It is the `X` axis and should always be real.
@recipe function ng(::NgSpiceGraphs, vectype, fort, veclist, title, xlims=nothing)
    ft = getrealvec(fort)
    label := permutedims(veclist)
    grid := true
    title := "$title"
    background_color --> Colors.RGB(0.0, 0.0, 0.0)
    xguide := fort
    guide := length(veclist) > 1 ? "signals" : "signal"
    color_palette --> :default
    seriestype := :path
    overwrite_figure := false
    vec = vectype.(veclist)
    #isa(xlims, Nothing) || xlims := xlims
    ft, vec
end

# source function for sp files needs to specially process plot commands
function source_sp(netpath)
    netlines = readlines(netpath)
    circpath = joinpath(pwd(), "net.cir")
    for l in range(1, stop=length(netlines))
        if netlines[l] == ".control" 
            open(circpath, "a") do f
                for line in netlines[1:l-1]
                    write(f, line*"\n")
                end 
            end
            try source(circpath) catch; rm(circpath) end
            temp = l
            while netlines[temp+1] != ".endc"
                temp += 1
                try 
                    if occursin("plot", netlines[temp])
                        _plotswitch(netlines[temp])
                    else
                        cmd(netlines[temp])
                    end
                catch
                    isfile(circpath) && rm(circpath)
                end
            end
        end
    end
    isfile(circpath) && rm(circpath)
end

function _plotswitch(pltstr)
    params = split(pltstr[6:end], " ")
    xlims = nothing
    xlim_index = findall(occursin.("xlim", params))
    length(xlim_index) == 0 || (xlim_index = xlim_index[1]; xlims = parse.(Float64, (params[xlim_index+1], params[xlim_index+2])); 
        deleteat!(params, xlim_index:1:xlim_index+2))
    fort = "frequency" ∈  listcurvecs() ? "frequency" : "time"
    pushfirst!(params, fort)
    if !occursin("-", params[1]) plt = plot(graph, getrealvec, params[1], params[2:end], "Real plot", xlims)
    elseif params[1] ∈ ("--real", "-r") plt = plot(graph, getrealvec, params[2], params[3:end], "Real plot", xlims)
    elseif params[1] ∈ ("--imaginary", "-i") plt = plot(graph, getimagvec, params[2], params[3:end], "Imaginary plot", xlims) 
    elseif params[1] ∈ ("--magnitude", "-m") plt = plot(graph, getmagnitudevec, params[2], params[3:end], "Magnitude plot", xlims)
    elseif params[1] ∈ ("--phase", "-p") plt = plot(graph, getphasevec, params[2], params[3:end], "Phase plot", xlims)
    else throw("$(params[1]) is not a valid plot type")
    end
    Base.display(plt)
end
