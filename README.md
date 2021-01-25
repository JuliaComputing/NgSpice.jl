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
To start an an interactive mode,
- Run `Ngspice.interactive()` in REPL

- Hit `~` for initializing the NgSpice

An example circuit:
```
source /filepath/netlist # without quotes
display                  # prints all vectors and constants
plot vector1 vector2     # plots the real part of vector by default
```


Note: It is not necessary for `.cir` to be placed in `bin` folder as long as full path is specified.

---
Plotting syntax:  `plot -x space seperated vectorlist` where `x` takes following modes:

| Modes | Description |
|---------|-------|
| -r, --real | Real part of vector|
| -i, --imaginary | Imaginary part of vector |
| -m, --magnitude | Magnitude of vector |
| -p, --phase | Phase of vector |

> Other commands to run an NgSpice simulation can be found [here](http://ngspice.sourceforge.net/docs/ngspice-html-manual/manual.xhtml#magicparlabel-21623). <br>
All commands that NgSpice allows can be found [here](http://ngspice.sourceforge.net/docs/ngspice-html-manual/manual.xhtml#sec_Commands).

