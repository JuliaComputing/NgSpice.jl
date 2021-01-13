#TODO: load_netlist(netlist::String) 

function load_netlist(netpath::String)
    netlist = open(f->read(f, String), netpath)
    netlist = split(netlist, "\r\n")
    append!(netlist, ["C_NULL"])
    netlist |> pointer |> ngSpice_Circ
end

function load_netlist2(netpath::String)
    netlist = open(f->read(f, String), netpath)
    netlist = split(netlist)
    for net in netlist

        netptr  = pointer(net) 
        netptrcs = convert(Ptr{Cstring}, netptr)
        ngSpice_Circ(netptrcs)
    end
end

#a = load_netlist(netpath)
