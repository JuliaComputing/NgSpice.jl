# NgSpice

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaComputing.github.io/NgSpice.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaComputing.github.io/NgSpice.jl/dev)
[![Build Status](https://github.com/JuliaComputing/NgSpice.jl/workflows/CI/badge.svg)](https://github.com/JuliaComputing/NgSpice.jl/actions)
[![Coverage](https://codecov.io/gh/JuliaComputing/NgSpice.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaComputing/NgSpice.jl)


This repository provides a Julia wrapper for NgSpice library.

## Usage:

In a Julia REPL,
```
] add https://github.com/JuliaComputing/NgSpice.jl
using NgSpice
```
---

To start an an interactive mode,
```
using Plots
NgSpice.interactive()
```

- Hit `~` for initializing the NgSpice

Run the Ngspice simulations commands! <br>
For example:
```
source /filepath/netlist # without quotes
display                  # prints all vectors and constants
plot vector1 vector2     # plots the real part of vector by default
```


*Note*: It is not necessary for `.cir` to be placed in `bin` folder as long as full path is specified.

Additional to usual plot parameters, different modes of retrieval can be set with:<br>
  `plot -x space seperated vectorlist` <br>
  where `x` takes following modes:

| Modes | Description |
|---------|-------|
| -r, --real | Real part of vector|
| -i, --imaginary | Imaginary part of vector |
| -m, --magnitude | Magnitude of vector |
| -p, --phase | Phase of vector |

---
For a non-interactive and more Julia-like experience checkout this [tutorial](tutorials\mosfet.jl).

Additionally, to simulate a `complex_circuit.sp` file with multiple plotting statements, run
```
using NgSpice
using Plots
source_sp("path/to/the/complex_circuit.sp")
```
