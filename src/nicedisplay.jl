module NiceDisplay

    using Reexport

    using DataFrames, DataFramesMeta
    using CategoricalArrays
    using Graphs, MetaGraphs
    using LinearAlgebra
    using PrettyTables # for nicedisplay()

    # @reexport using TexTables, using PrettyTables
    @reexport using CairoMakie, AlgebraOfGraphics
    @reexport using ColorSchemes, Colors
    @reexport using GraphMakie
    
    for x in [
        "plot_utilities.jl",
        "graphplot_utilities.jl",
        "niceout.jl"
        ]
        include(x)
    end
end
