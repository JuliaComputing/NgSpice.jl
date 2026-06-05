# NgHerb -- A Revision of NgSpice


This repository provides a Julia wrapper for NgSpice library. It's based on the 
[NgSpice](https://github.com/JuliaComputing/NgSpice.jl) Julia module by Venkateshprasad Bhat. 
NgHerb implements these changes:

* Thread safety for NgSpice callbacks, to resolve segfaults in Julia 12.6+
* Removed unused callbacks
* Removed REPL and Plot features for easier maintenance

NgHerb has some additional streamlining compared to NgSpice. 

The main purpose is to provide a minimal `ngspice` library wrapper that works stably with more recent
Julia versions. As of Julia 12.6, the original NgSpice module is broken unless
Julia is constrained to one thread, i.e. `julia -t 1`. NgHerb tries to fix this by
introducing a CircularBuffer to manage asyncrhonous output from the `ngspice`.


## Usage:

In a Julia REPL,
```
] add https://github.com/cjwinstead/NgHerb.jl
using NgHerb
```
---

Upon initialization, you shold see a startup message from the `ngspice` library, something
like this:

```
******
** ngspice-46 shared library
** Creation Date: Tue May 12 23:05:42 UTC 2026
******
```

### Basic Functions

To load a netlist and run analyses in `ngspice`, use:

* `NgHerb.load_netlist(String)` -- loads a netlist from a multi-line Julia String
* `NgHerb.cmd(String)` -- run an `ngspice` command.

To retrieve data from `ngspice`, use:

* `NgHerb.getrealvec(String)` -- get the named vector 
* `NgHerb.getmagnitudevec(String)` -- get the magnitude of a complex vector
* `NgHerb.getphasevec(String)` -- get the phase of a complex vector (radians)


```julia-repl
julia> netlist="""
* Demo circuit

V1 1 0 DC 1
R1 1 2 1k
R2 2 0 2k

.end
""";

julia> NgHerb.load_netlist(netlist)
Circuit: * Demo circuit

julia> NgHerb.cmd("op")

Doing analysis at TEMP = 27.000000 and TNOM = 27.000000
Using SPARSE 1.3 as Direct Linear Solver
No. of Data Rows : 1

julia> NgHerb.cmd("print all");

v(1) = 1.000000e+00
v(2) = 6.666667e-01
v1#branch = -3.33333e-04

julia> NgHerb.getrealvec("2")
1-element Vector{Float64}:
 0.6666666666666666

```

## String Macros

Some special strings are defined to conveniently interface with `ngspice`:

* `ng"..."` -- shorthand for NgHerb.cmd()
* `vec"..."` -- returns the indicated vector (with name and type)

These string types all return `Vector{Float64}`:

* `real"..."` -- real part of the indicated `ngspice` vector
* `imag"..."` -- imaginary part of the indicated `ngspice` vector
* `magnitude"..."` -- complex magnitude of the indicated vector
* `phase"..."` -- complex phase (in degrees)
* `dB"..."` -- magnitude in dB20
* `i"..."` -- real-valued branch current in the indicated voltage source

