# plot_utilities.jl

# colors
oi = wc = Makie.wong_colors(); # Okabe-Ito colors
berlin = colorschemes[:berlin];

export wc, oi, berlin

# functions to set common plotting parameters

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

yale = (
    lblue = parse(Colorant, "#63aaff"),
    blue = parse(Colorant, "#00356b"),
    ora = parse(Colorant, "#bd5319"),
    dgrey = parse(Colorant, "#4a4a4a"),
    mgrey = parse(Colorant, "#978d85")
);

export yale
