module NiceDisplay
    
    using Colors
    using DataFrames
    # using LinearAlgebra
    using PrettyTables # for nicedisplay()
    
    for x in [
        "plot utilities.jl",
        "graphplot utilities.jl",
        "nice out.jl",
        "colors.jl"
    ]
        include(x)
    end
end
