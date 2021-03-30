function load_netlist(netpath::String)
    netlist = readlines(netpath)
    append!(netlist, ["C_NULL"])
    t = netlist |> ngSpice_Circ
end

source(netpath) = cmd("source $netpath")

display() = cmd("display")
