using RecipesBase
using Colors

# Plotting the graphs with frequency as X-axis

struct NgSpiceGraphs end

const graph = NgSpiceGraphs()

@recipe function ng(::NgSpiceGraphs, fort, veclist, title)
    ft = getrealvec(fort)
    legend := true
    grid := true
    title := "$title"
    background_color --> Colors.RGB(0.0, 0.0, 0.0)
    xguide := fort
    color_palette --> :default
    seriestype := :path
    vec = getrealvec.(veclist)
    ft, vec
end

@recipe function ng(::NgSpiceGraphs, vectype, fort, veclist, title)
    ft = getrealvec(fort)
    legend := true
    grid := true
    guide := "$title"
    background_color --> Colors.RGB(0.0, 0.0, 0.0)
    xguide := fort
    color_palette --> :default
    seriestype := :path
    vec = vectype.(veclist)
    ft, vec
end