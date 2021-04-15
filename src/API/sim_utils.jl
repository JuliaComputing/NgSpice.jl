function load_netlist(netlist::Array{String})
    append!(netlist, ["C_NULL"])
    t = netlist |> ngSpice_Circ
end

function load_netlist(netpath::String)
    netlist = readlines(netpath)
    load_netlist(netlist)
end

source(netpath) = cmd("source $netpath")

display() = cmd("display")
