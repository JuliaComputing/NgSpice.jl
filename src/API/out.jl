using DataFrames

function ngdisplay()
    plotlist = listallplots()
    for p in plotlist
        p == "const" && continue
        println("--- The vectors in plot $p ---")
        veclist = listcurvecs(p)
        df = DataFrame(Name = String[], Type = String[], DataType = Type[], Length = Int[])
        for v in veclist
            vname, vtype, vdata = getvec(v)
            push!(df, (vname, vtype, typeof(vdata), sizeof(vdata)))
        end
        df |> print
    end
end

function vecswitch(vecstr)
    if !occursin("-", vecstr) return getrealvec
    elseif vecstr ∈ ("--real", "-r") return getrealvec
    elseif vecstr ∈ ("--imaginary", "-i")  return getimagvec
    elseif vecstr ∈ ("--magnitude", "-m") return getmagnitudevec
    elseif vecstr ∈ ("--phase", "-p") return getphasevec
    end
end

function ngprint(params)
    if !occursin("-", params[1])
        veclist = getrealvec.(params)
        DataFrame(Dict(zip(params, veclist))) |> print
    else
        getthisvec = vecswitch(params[1])
        veclist = getthisvec.(params[2:end])
        DataFrame(Dict(zip(params[2:end], veclist[2:end]))) |> print
    end
end
