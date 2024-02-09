module NiceDisplay

    using Reexport

    using MixedModels, Distributions, GLM, StatsModels
    using DataFrames, DataFramesMeta
    using CategoricalArrays
    using Graphs, MetaGraphs
    using LinearAlgebra

    @reexport using TexTables, PrettyTables
    @reexport using CairoMakie, AlgebraOfGraphics
    @reexport using ColorSchemes, Colors
    @reexport using GraphMakie
    
    for x in [
        "plot_utilities.jl", "quarto_utilities.jl",
        "regtables.jl", "nicedisplay.jl",
        "typst.jl"
    ]
        include(x)
    end

    # for x in ["roc-style.jl"]
    #     include("figures/" * x)
    # end

    nd = nicedisplay;
    export nd
end
