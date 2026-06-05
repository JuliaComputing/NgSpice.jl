 function load_netlist(netlist::AbstractArray{T}) where T <: AbstractString
     append!(netlist, ["C_NULL"])
     t = netlist |> ngSpice_Circ
 end

# Opted to use the "circbyline" approach here to reduce
# memory crossover events between Julia and NgSpice.
function load_netlist(netlist::AbstractString)
    for line in eachsplit(netlist,"\n")
        if contains(line,r"\w+")
            cmd(string("circbyline ",line))
        end
    end
    if !contains(lowercase(netlist),r"\.end\s*$")
        cmd("circbyline .end")
    end
end

source(netpath) = cmd("source $netpath")

display() = cmd("display")
