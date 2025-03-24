module NiceDisplay
    
    using Reexport
    
    using DataFrames
    using LinearAlgebra
    using PrettyTables # for nicedisplay()

    using HondurasTools
    
    @reexport using Colors
    @reexport using ColorSchemes
    @reexport using CairoMakie

    using HondurasTools.Graphs
    using HondurasTools.MetaGraphs
    using GraphMakie
    
    for x in [
        "plot utilities.jl",
        "graphplot utilities.jl",
        "nice out.jl",
        "colors.jl"
    ]
        include(x)
    end
end
