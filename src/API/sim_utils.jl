function load_netlist(netlist::AbstractArray{T}) where T <: AbstractString
    append!(netlist, ["C_NULL"])
    t = netlist |> ngSpice_Circ
end

function load_netlist(net::AbstractString)
    isfile(net) && (netlist = readlines(net);
        load_netlist(netlist);
        return)
    # The strings in Julia always use \n instead of \r \r\n
    # (even if the editor does).
    # But if the circuit-string has \r in it,
    # uncomment the following line
    # occursin("\r", net) && replace(net, "\r"=>"")
    load_netlist(split(net, "\n"))
end

source(netpath) = cmd("source $netpath")

display() = cmd("display")
