function load_netlist(netlist::AbstractArray{T}) where T <: AbstractString
    # Each line must be its own NUL-terminated String: a SubString (e.g. from
    # `split`) points into its parent string, so ngspice would read past the end
    # of the line. Julia appends the terminating NULL pointer itself when it
    # converts the Vector{String} for ccall. The caller's array is not modified.
    ngSpice_Circ(String[String(l) for l in netlist])
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
