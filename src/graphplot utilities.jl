# graphplot_utilities.jl

function node_properties(g, v; c = "#00356b")
    node_color = fill(RGBA(0,0,0), nv(g))
    node_color[v] = parse(Colorant, c)
    node_size = fill(12, nv(g))
    node_size[v] = 36
    return node_color, node_size
end

export node_properties
