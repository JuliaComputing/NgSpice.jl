function load_netlist(netpath::String)
    netlist = open(f->read(f, String), netpath)
    netlist = split(netlist, "\r\n")
    #netlist = replace(netlist, "\r\n" => "")
    append!(netlist, ["C_NULL"])
    t = netlist |> pointer |> ngSpice_Circ
end
