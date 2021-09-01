using NgSpice
using Plots
n = NgSpice

netpath = joinpath(@__DIR__, "..", "inputs", "mosfet.cir") |> normpath

n.init()
n.source(netpath)
n.run()
n.display()        # Returns a dataframe of current vectors 
n.listallvecs()    # Lists vectors of both active and inactive plots
n.curplot()        # Current active plot
n.listcurvecs()    # Vectors in current active plot
# Vector type can be specified by sending it as a parameter
# plot(n.graph, n.getimagvec, "time", ["emit", "vcc"], "Title of the plot")
sweep = n.getvec("time")[end]   # Returns vector info of `time` vector 
emit = n.getvec("emit")[end]   # Returns vector info of `emit` vector 
vcc = n.getvec("vcc")[end]   # Returns vector info of `vcc` vector 
plot(sweep, [emit vcc], label=["emit" "vcc"], title="Title of the plot")
n.exit()           # Runs "unset askquit" of Ngspice
