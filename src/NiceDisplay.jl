module NiceDisplay

    using Reexport

    using MixedModels, Distributions, GLM, StatsModels
    using DataFrames, DataFramesMeta
    using CategoricalArrays
    @reexport using TexTables, PrettyTables
    @reexport using CairoMakie, ColorSchemes, Colors
    @reexport using AlgebraOfGraphics
    
    for x in [
        "plot_utilities.jl", "quarto_utilities.jl",
        "regtables.jl", "nicedisplay.jl", "unitbarplot.jl"
    ]
        include(x)
    end

    # for x in ["roc-style.jl"]
    #     include("figures/" * x)
    # end

    nd = nicedisplay;
    export nd
end
