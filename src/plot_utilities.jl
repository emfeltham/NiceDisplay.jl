# plot_utilities.jl

# functions to set common plotting parameters
# try to limit this to prevent lots of confusing plot functions

function yxline!(ax)
    lines!(ax, 0:.01:1, 0:.01:1, color = :black, linestyle = :dot)
end

export yxline!

function linehist!(ax, x; bins = nothing, color = nothing, fx = mean)
    if isnothing(bins)
        hist!(ax, x)
    else
        hist!(ax, x; bins = bins)
    end
    if isnothing(color)
        vlines!(ax, fx(x))
    else
        vlines!(ax, fx(x); color = color)
    end
end

# include("new analysis cleaning.jl");

# colors
oi = wc = Makie.wong_colors(); # Okabe-Ito colors
berlin = colorschemes[:berlin];
fext = ".svg"

export fext, wc, oi, berlin

"""
        labelpanels!(los; lbs = nothing)

## Description

Add labels to GridLayouts in `los`. Add custom labels as `lbs`, defaults to
alphabetical enumeration.

"""
function labelpanels!(los; lbs = nothing)
    lbs = if isnothing(lbs)
        string.(collect('A':'Z'))[1:length(los)]
    else
        lbs
    end
    for (label, layout) in zip(lbs, los)
        Label(layout[1, 1, TopLeft()], label,
            fontsize = 26,
            font = :bold,
            padding = (0, 5, 5, 0),
            halign = :right)
    end
end

export labelpanels!

## perceiver plot utilities

function node_properties(g, v; c = "#00356b")
    node_color = fill(RGBA(0,0,0), nv(g))
    node_color[v] = parse(Colorant, c)
    node_size = fill(12, nv(g))
    node_size[v] = 36
    return node_color, node_size
end

export node_properties

# lblue is orbitcolor
yale = (
    lblue = parse(Colorant, "#63aaff"),
    blue = parse(Colorant, "#00356b"),
    ora = parse(Colorant, "#bd5319"),
    dgrey = parse(Colorant, "#4a4a4a"),
    mgrey = parse(Colorant, "#978d85")
);

export yale
