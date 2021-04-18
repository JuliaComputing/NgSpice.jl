function load_netlist(netlist::AbstractArray{T}) where T <: AbstractString
    append!(netlist, ["C_NULL"])
    t = netlist |> ngSpice_Circ
end

function load_netlist(netlist::AbstractString)
    # The strings in Julia always use \n instead of \r \r\n
    # (even if the editor does).
    # But if the circuit-string has \r in it,
    # uncomment the following line
    # occursin("\r", netlist) && replace(netlist, "\r"=>"")
    load_netlist(split(netlist, "\n"))
end

source(netpath) = cmd("source $netpath")

display() = cmd("display")
