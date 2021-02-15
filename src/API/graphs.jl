using RecipesBase
using Plots

# Plotting the graphs with frequency as X-axis

struct SemiLogType end

const sl = SemiLogType()

@recipe function plot(::SemiLogType, fort::Vector, vec::Vector, title, xname, vecname)
    legend := true
    guide := "$title"
    xguide := xname
    background_color --> RGB(0.0, 0.0, 0.0)
    color_palette --> :default
    seriestype := :path 
    fort, vec 
end

function semilogplot(plottype, vecname, title, maxlen=Int(maxintfloat()))
    vec = plottype.(vecname, maxlen)
    fort, xname = Nothing, ""
    try
        fort = getrealvec("time", maxlen)
        xname = "Time"
    catch (e)
        fort = getrealvec("frequency", maxlen)
        xname = "Frequency"
    end
    plot(sl, fort, vec, title, xname, vecname)
end
