include("netlist.jl")
include("C:\\Users\\jedi\\.julia\\dev\\Ngspice\\src\\Ngspice.jl")
convert(T::Cstring, p::Ptr{Cstring}) = convert(Ptr{UInt8}, p) |> unsafe_string

fpgen(a, fp) = (a=a; convert(Ptr{fp}, a))
netpath = "C:\\Users\\jedi\\.julia\\dev\\Ngspice\\src\\API\\test.txt"
netpath4 = "C:\\Users\\jedi\\.julia\\dev\\Ngspice\\inputs\\ac_ascii.cir"

netpath2 = "C:\\Users\\jedi\\.julia\\dev\\Ngspice\\inputs\\mosfet.cir"
netpath3 = "C:\\Users\\jedi\\.julia\\dev\\Ngspice\\src\\API\\test2.txt"
#ptr = Ptr{UInt8}[pointer(["source", "C:\\Users\\jedi\\.julia\\dev\\Ngspice\\inputs\\ac_ascii.cir"])]
#unsafe_wrap(ptr[1])
n = Ngspice
n.start()
n.load_netlist(netpath4)

curr = n.ngSpice_CurPlot()
allvecs = n.ngSpice_AllVecs(curr)
allvin = convert(Ptr{UInt8}, allvecs)
vecinf = n.ngGet_Vec_Info(plotvin)
dump(vecinf)
unsafe_load(vecinf.v_realdata)
unsafe_load(vecinf.v_compdata)
unsafe_string(Ptr{UInt8}[vecinf.v_name][1])
n._command(:C_NULL)
n.reset()
n.halt()
n.isrunning()
vecinf.v_name
allplots = n.ngSpice_AllPlots()
plotvin = convert(Ptr{UInt8}, allplots)


netlist = open(f->read(f, String), netpath3)
netlist = replace(netlist, "\r\n" => "\n")
netlist = split(netlist, "\r\n")
append!(netlist, ["C_NULL"])
for net in netlist println(net) end
netptr  = Ptr{UInt8}[pointer(netlist)]
netptr  = [Ptr{UInt8}[pointer(net)] for net in netlist]
netptr[1]
unsafe_string(p)
netptr[1]
p = pointer(netlist)
a = ["asdsaf", "sdfd"]
ap = pointer(a)
aps = Ptr{UInt8}[pointer(a)]
ngSpice_Circ(netptr[1])
ngSpice_Circ(netptr)
ngSpice_Circ(aps)
ngSpice_Circ(netptr[4])
ngSpice_Circ(netptr[i])
for i in range(1, stop=length(netptr))
    #println(net)
    #netptr = Ptr{UInt8}[pointer(net)]
    ngSpice_Circ(netptr[i])
    println(netptr[i])
end
ngSpice_Circ(netlist)
pointer.(netlist)

netlist2 = open(f->read(f, String), netpath)
netlist2 = split(netlist2, "\n")

pointer.(netlist)

ngSpice_Command("write testout.raw V(2)");
ngSpice_Command("print V(2)");

ngSpice_Command("circbyline fail test")
ngSpice_Command("circbyline V1 1 0 1")
ngSpice_Command("circbyline R1 1 0 1")
ngSpice_Command("circbyline .dc V1 0 1 0.1")
ngSpice_Command("circbyline .end")

const sc = Ptr{Ngspice.SendChar} 
const ss = Ptr{Ngspice.SendStat}
const ce = Ptr{Ngspice.ControlledExit}
const sd = Ptr{Ngspice.SendData}
const sid =Ptr{Ngspice.SendInitData}
const bgt =Ptr{Ngspice.BGThreadRunning}

convert(fptr, a)
scp = convert(sc, 1)
ssp= convert(ss, 1)
cep = convert(ce, 1)
sdp = convert(sd, 1)
sidp = convert(sid, 1)
bgtp = convert(bgt, 1)
vp = convert(Ptr{Nothing}, 0)
# define a validate function to validatethe cmd before f call                  
ngSpice_Init(scp, ssp, cep, sdp, sidp, bgtp, vp)
ngSpice_Init(vp, sendstat, vp, vp, sendinitdata, vp, vp)
sendinitdata
print(unsafe_load(sendinitdata))
isrunning()
init()
start()
load_netlist(netpath)