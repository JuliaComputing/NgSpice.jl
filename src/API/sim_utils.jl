function load_netlist(netlist::AbstractArray{T}) where T <: AbstractString
    append!(netlist, ["C_NULL"])
    t = netlist |> ngSpice_Circ
end

function load_netlist(netpath::AbstractString)
    netlist = readlines(netpath)
    load_netlist(netlist)
end

function load_netlist_str(netlist::AbstractString)
    load_netlist(split(netlist))
end

source(netpath) = cmd("source $netpath")

display() = cmd("display")
