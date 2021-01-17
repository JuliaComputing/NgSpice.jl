# Ngspice

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaComputing.github.io/Ngspice.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaComputing.github.io/Ngspice.jl/dev)
[![Build Status](https://github.com/JuliaComputing/Ngspice.jl/workflows/CI/badge.svg)](https://github.com/JuliaComputing/Ngspice.jl/actions)
[![Coverage](https://codecov.io/gh/JuliaComputing/Ngspice.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaComputing/Ngspice.jl)


This repository provides a Julia wrapper for Ngspice library.

## Usage:

In a Julia REPL,
```
] add https://github.com/JuliaComputing/Ngspice.jl
using Ngspice
```
You can run all the commands in an interactive mode by running,
`cmd("the_command")`

> Commands to run an Ngspice simulation can be found [here](http://ngspice.sourceforge.net/docs/ngspice-html-manual/manual.xhtml#magicparlabel-21623). <br>
All commands that Ngspice allows can be found [here](http://ngspice.sourceforge.net/docs/ngspice-html-manual/manual.xhtml#sec_Commands).

---

Example to load a circuit and display all variables:
```
netpath = "path to .cir file"
init()
cmd("source $netpath") 
cmd(:display)
cmd(:run)
```

Note that it is not necessary for `.cir` to be placed in `bin` folder as long as the path is specified.

---
`plot` refers to vectors in Ngspice. Any functions affixed with `plot` uses it in the same meaning.
