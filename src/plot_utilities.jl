# plot_utilities.jl
# colors

global oi = wc = Makie.wong_colors(); # Okabe-Ito colors
global berlin = colorschemes[:berlin];

export wc, oi, berlin

global yale = (
    lblue = parse(Colorant, "#63aaff"),
    blue = parse(Colorant, "#00356b"),
    ora = parse(Colorant, "#bd5319"),
    dgrey = parse(Colorant, "#4a4a4a"),
    mgrey = parse(Colorant, "#978d85")
);

export yale

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
        labelpanels!(los; lbs = :lowercase)

## Description

Add labels to GridLayouts in `los`. Add custom labels as `lbs`, defaults to
alphabetical enumeration.

- `lbs`: one of `:lowercase`, `:uppercase`, or a vector of labels at least as long as `los` vector of layouts.

"""
function labelpanels!(los; lbs = :lowercase)
    lbs = if lbs == :uppercase
        string.(collect('A':'Z'))[1:length(los)]
    elseif lbs == :lowercase
        string.(collect('a':'z'))[1:length(los)]
    else
        @assert length(los) <= length(lbs)
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
