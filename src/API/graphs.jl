using Plots

# Plotting the graphs with frequency as X-axis

function semilogplot(plottype, vecname, title, maxlen=Int(maxintfloat()))
    vec = plottype.(vecname, maxlen)
    f   = getrealvec("frequency", maxlen)
    gr()
    plot(f, xaxis=:log, vec, background_color=RGB(0.0,0.0,0.0), leg=true, labels=permutedims(vecname))
    title!(title)
    xlabel!("frequency")
    ylabel!("V")
end



