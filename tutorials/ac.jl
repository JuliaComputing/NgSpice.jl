#This simulates the ac_ascii file

joinpath(@__DIR__, "..", "src/Ngspice.jl") |> normpath |> include
n = Ngspice
netpath = joinpath(@__DIR__, "..", "inputs/RC2.net") |> normpath

n.load_netlist(netpath)
n.start()
n.get_vector("frequency")
n.get_vector("n0")

#=
function get_vector(vecname)
    vec  = n.ngGet_Vec_Info(vecname)
    vec != convert(Ptr{Nothing}, 0) || throw("Points to null")
    vname  = unsafe_load(convert(Ptr{UInt8}, vec.name))
    vreal  = unsafe_load(vec.realdata)
    _cmp = unsafe_load(vec.compdata)
    vcmplx = Complex(_cmp.real, _cmp.imag)
    return vname, vreal, vcmplx
end=#

#=
curr    = n.ngSpice_CurPlot()
allvecs = n.ngSpice_AllVecs(curr)
unsafe_string(allvecs)
allvin  = convert(Ptr{UInt8}, allvecs)
vecinf  = n.ngGet_Vec_Info(allvecs)
unsafe_load(vecinf.realdata)
unsafe_load(vecinf.compdata)
unsafe_load(vecinf.type)=#