using ReplMaker

function _ngspice_repl_parser(str)
    if str == "init" init()
    elseif occursin("plot", str)
        params = split(str[6:end], " ")
        if !occursin("-", params[1]) semilogplot(getrealvec, params, "Real plot")
        elseif params[1] ∈ ("--real", "-r") semilogplot(getrealvec, params[2:end], "Real plot")
        elseif params[1] ∈ ("--imaginary", "-i") semilogplot(getimagvec, params[2:end], "Imaginary plot") 
        elseif params[1] ∈ ("--magnitude", "-m") semilogplot(getmagnitudevec, params[2:end], "Magnitude plot")
        elseif params[1] ∈ ("--phase", "-p") semilogplot(getphasevec, params[2:end], "Phase plot")
        else throw("$(params[1]) is not a valid plot type")
        end
    else cmd(str)
    end
end

interactive() = (init(); 
           initrepl(_ngspice_repl_parser,
                  prompt_text  = "NgSpice> ",
                  prompt_color = :yellow,
                  start_key    = '~',
                  mode_name    = "for NgSpice is",
                  ))

