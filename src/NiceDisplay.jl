module NiceDisplay
    
    using Reexport
    
    using DataFrames
    using LinearAlgebra
    using PrettyTables # for nicedisplay()
    
    @reexport using Colors
    @reexport using CairoMakie
    
    for x in [
        "plot utilities.jl",
        "graphplot utilities.jl",
        "nice out.jl",
        "colors.jl"
    ]
        include(x)
    end
end
