using ReplMaker
using .Plots

function _ngspice_parser(str)
    if str == "init" init()       
    elseif occursin("plot", str)
        plotswitch(str)
    elseif occursin("print", str)
        params = split(str[7:end], " ")
        getthisvec = vecswitch(params[1])
        open("Vectors.txt", "w") do f 
            for vec in params
                val = getthisvec(vec)
                write(io, "$vec = [")
                writedlm(f, val)
                write(io, " ]")
            end
        end
    else 
        cmd(str)
    end
end

function _sp_parser_seperator(str)
    f = open(str)
    s = read(f, String)
    close(f)
    replace(s, "\r\n"=>"\n")
    a = split(s, "\r\n")
    println("Seperating .control from netlist")
    control = []
    for l in range(1, stop=length(a))
        
            if a[l] == ".control"
                print("inside control")
                open("temp.cir", "w") do f
                    for line in a[1:l-1]
                        println("$line")
                        write(f, line*"\r\n")
                    end
                    write(f, ".endc")
                end
                println("Created a temporary circuit file")
                cmd("source temp.cir")
                while a[l+1] !=  ".endc"
                    append!(control, a[l+1])
                end
                
                endc = l+1
                if a[endc+1] != ".end"
                    println("Few commands after .control ends")
                end
            #=elseif a[l] == ".print"

                
                params = split(str[7:end], " ")
                getthisvec = vecswitch(params[1]) 
                println(getthisvec(params[2:end]))=#
            end
        
    end
    for con in control
        println(con)
        con != "run" && _ngspice_parser(con)
    end
end

function _sp_parser(str)
    cmd(str)
    f = open(str)
    s = read(f, String)
    close(f)
    replace(s, "\r\n"=>"\n")
    a = split(s, "\r\n")
    for l in range(1, stop=length(a))
        if a[l][1] == '.'
            if a[l] == ".control"
                temp = l
                while a[temp+1] != ".endc"
                    temp += 1
                    if occursin("plot", a[temp])
                        plotswitch(a[temp])
                    end
                end
            
            elseif occursin(".print", a[l])
                params = split(str[7:end], " ")
                getthisvec = vecswitch(params[1])
                vec = getthisvec.(params[2:end]) 
                println(vec)
            end
        end
    end
end

function vecswitch(vecstr)
    if !occursin("-", vecstr) return getrealvec
    elseif vecsrtr ∈ ("--real", "-r") return getrealvec
    elseif vecstr ∈ ("--imaginary", "-i")  return getimagvec
    elseif vecstr ∈ ("--magnitude", "-m") return getmagnitudevec
    elseif vecstr ∈ ("--phase", "-p") return getphasevec
    end
end


function plotswitch(pltstr)
    params = split(pltstr[6:end], " ")
    if !occursin("-", params[1]) plot(graph, getrealvec, params[1], params[2:end], "Real plot")
    elseif params[1] ∈ ("--real", "-r") plot(graph, getrealvec, params[2], params[3:end], "Real plot")
    elseif params[1] ∈ ("--imaginary", "-i") plot(graph, getimagvec, params[2], params[3:end], "Imaginary plot") 
    elseif params[1] ∈ ("--magnitude", "-m") plot(graph, getmagnitudevec, params[2], params[3:end], "Magnitude plot")
    elseif params[1] ∈ ("--phase", "-p") plot(graph, getphasevec, params[2], params[3:end], "Phase plot")
    else throw("$(params[1]) is not a valid plot type")
    end
end

function _repl_parser(str)
    if occursin(".sp", str) && str[1:7] == "source "
        _sp_parser(str[8:end])
    else
        _ngspice_parser(str)
    end
end

interactive() = (init(); 
           initrepl(_repl_parser,
                  prompt_text  = "NgSpice> ",
                  prompt_color = :yellow,
                  start_key    = '~',
                  mode_name    = "for NgSpice is",
                  ))

