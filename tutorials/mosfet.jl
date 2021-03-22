using NgSpice
n = NgSpice

netpath = joinpath(@__DIR__, "inputs", "mosfet.cir")

n.init()
n.source(netpath)
n.run()
n.display()        # Returns a dataframe of current vectors 
n.listallvecs()    # Lists vectors of both active and inactive plots
n.curplot()        # Current active plot
n.listcurvecs()    # Vectors in current active plot
n.getvec("emit")   # Returns vector info of `emit` vector 
plot(n.graph, "time", ["emit", "vcc"], "Title of the plot")
# Vector type can be specified by sending it as a parameter
# plot(n.graph, n.getimagvec, "time", ["emit", "vcc"], "Title of the plot")
n.exit()           # Runs "unset askquit" of Ngspice
