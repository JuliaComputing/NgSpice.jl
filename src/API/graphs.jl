using RecipesBase
using Colors

# Plotting the graphs with frequency as X-axis

struct NgSpiceGraphs end

const graph = NgSpiceGraphs()

@recipe function p(::NgSpiceGraphs, fort, veclist, title)
    ft = getrealvec(fort)
    legend := true
    grid := true
    guide := "$title"
    background_color --> Colors.RGB(0.0, 0.0, 0.0)
    xguide := fort
    color_palette --> :default
    seriestype := :path
    vec = getrealvec.(veclist)
    ft, vec
end
