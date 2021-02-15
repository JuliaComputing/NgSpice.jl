using NgSpice
n = NgSpice

n.init()
n.cmd("source C:\\Users\\jedi\\.julia\\dev\\Ngspice\\inputs\\top.sp")

# "time" is time vector
# "e2#branch", "vinput#branch" are current vectors
# rest are voltage vectors
# "allvecs" lists all vectors available in this sim

allvecs = ["input", "input_q", "i", "q", "time", "output", "x1.i1", "x1.i2", "x1.i3", "x1.i4", "x1.i5", 
            "x1.q1", "x1.q2", "x1.q3", "x1.q4", "x1.q5", "x1.r1", "x1.r2", "x1.r3", "x1.r4",
            "e2#branch", "vinput#branch"]

#get vectors by

for v in allvecs
    vect = n.getrealvec(v) # returns vector
    # println(vect) 
    # can be taken for surrogatization
end


# Examples For plotting the graphs

n.semilogplot(getrealvec, ["input", "output", <any vector name>], "Real plot")