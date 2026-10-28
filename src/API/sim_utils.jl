"""
    load_netlist(lines::Vector{String})

Send a netlist to ngspice with `ngSpice_Circ`. The vector is not modified;
Julia appends the terminating NULL pointer itself when it converts the vector
for the ccall.
"""
function load_netlist(netlist::Vector{String})
    ngcall(() -> ngSpice_Circ(netlist))
    return nothing
end

# Opted to use the "circbyline" approach here to reduce
# memory crossover events between Julia and NgSpice.
function load_netlist(netlist::String)
    # Hold the lock for the whole netlist so lines from two tasks cannot interleave.
    @lock NGSPICE_LOCK begin
        for line in eachsplit(netlist, "\n")
            if contains(line, r"\w+")
                cmd(string("circbyline ", line))
            end
        end
        if !contains(lowercase(netlist), r"\.end\s*$")
            cmd("circbyline .end")
        end
    end
    return nothing
end
precompile(load_netlist, (String,))
precompile(load_netlist, (Vector{String},))

source(netpath::String) = cmd("source $netpath")

display() = cmd("display")
