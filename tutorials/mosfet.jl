using NgSpice
# using Plots
n = NgSpice

netpath = joinpath(@__DIR__, "..", "inputs", "mosfet.cir") |> normpath

n.init()
n.source(netpath)
n.run()
n.display()        # Returns a dataframe of current vectors 
n.listallvecs()    # Lists vectors of both active and inactive plots
n.curplot()        # Current active plot
n.listcurvecs()    # Vectors in current active plot

# For plotting the signals, pass `n.graph` an object of `NgSpiceGraphs` type.
# And then, specify the get-vector method.
# Pass "time" or "frequency"
# List of signals to plot
# Finally, the title of the plot
# plot(n.graph, n.getimagvec, "time", ["emit", "vcc"], "Simple MOSFET")
# plot(n.graph, n.getrealvec, "time", ["emit", "vcc"], "Simple MOSFET")
