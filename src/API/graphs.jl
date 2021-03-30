using RecipesBase
using Colors
using .Plots

struct NgSpiceGraphs end

const graph = NgSpiceGraphs()

@recipe function ng(::NgSpiceGraphs, fort, veclist, title)
    ft = getrealvec(fort)
    legend := true
    grid := true
    title := "$title"
    background_color --> Colors.RGB(0.0, 0.0, 0.0)
    xguide := fort
    guide := String.(veclist)
    color_palette --> :default
    seriestype := :path
    vec = getrealvec.(veclist)
    ft, vec
end

@recipe function ng(::NgSpiceGraphs, vectype, fort, veclist, title)
    ft = getrealvec(fort)
    legend := true
    grid := true
    title := "$title"
    background_color --> Colors.RGB(0.0, 0.0, 0.0)
    xguide := fort
    guide := String.(veclist)
    color_palette --> :default
    seriestype := :path
    vec = vectype.(veclist)
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
            source(circpath)
            temp = l
            while netlines[temp+1] != ".endc"
                temp += 1
                if occursin("plot", netlines[temp])
                    _plotswitch(netlines[temp])
                else
                    cmd(netlines[temp])
                end
            end
        end
    end
    rm(circpath)
end

function _plotswitch(pltstr)
    params = split(pltstr[6:end], " ")
    fort = "frequency" ∈  listcurvecs() ? "frequency" : "time"
    pushfirst!(params, fort)
    if !occursin("-", params[1]) plot(graph, getrealvec, params[1], params[2:end], "Real plot")
    elseif params[1] ∈ ("--real", "-r") plot(graph, getrealvec, params[2], params[3:end], "Real plot")
    elseif params[1] ∈ ("--imaginary", "-i") plot(graph, getimagvec, params[2], params[3:end], "Imaginary plot") 
    elseif params[1] ∈ ("--magnitude", "-m") plot(graph, getmagnitudevec, params[2], params[3:end], "Magnitude plot")
    elseif params[1] ∈ ("--phase", "-p") plot(graph, getphasevec, params[2], params[3:end], "Phase plot")
    else throw("$(params[1]) is not a valid plot type")
    end
end