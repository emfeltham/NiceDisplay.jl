# plot_utilities.jl

# functions to set common plotting parameters

function yxline!(ax; linestyle = :dot, color = :black, kwargs...)
    lines!(ax, 0:.001:1, 0:.001:1; linestyle, color, kwargs...)
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
