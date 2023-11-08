# hhbarplot.jl

"""
        unitbarplot(
            hh, thing; wave = nothing, prop = true, unit = :village_code
        )

By-unit stacked barplot for distribution of (binary-) categorical-valued `thing`.
"""
function unitbarplot(
    dfin, thing;
    wave = nothing, prop = true, unit = :village_code, 
    clrs = colorschemes[:tol_light],
    colsize = Relative(2/3)
)

    df = deepcopy(dfin)

    df[!, unit] = levelcode.(df[!, unit])

    code = :code
    if nonmissingtype(eltype(df[!, thing])) == Bool
        df[!, thing] = categorical(string.(df[!, thing]))
    end
    replace!(df[!, thing], missing => "missing")
    
    if !isnothing(wave)
        @subset! df :wave .== wave
    end

    df = @chain df begin
        groupby([unit, thing])
        combine(nrow => :n)
        groupby(unit)
        DataFramesMeta.transform(:n => sum)
        @transform(_, :prop = :n ./ :n_sum)
        dropmissing()
    end
    
    df.code = CategoricalArrays.levelcode.(df[!, thing])
    vr = if prop
        :prop
    else
        :n
    end

    # :Set1_9

    ur = replace(string(unit), "_" => " ")

    fg = Figure();

    lo = fg[1, 1:2] = GridLayout();
    l1 = lo[1, 1] = GridLayout();
    ll = lo[1, 2] = GridLayout();
    ax1 = Axis(
        l1[1,1], xlabel = ur,
        ygridvisible = false, xgridvisible = false
    );

    barplot!(
        ax1, df[!, unit], df[!, vr],
        stack = df[!, code],
        color = clrs[df[!, code].+1]# [wc[i+1] for i in relsum.relcode],
    )

    # Legend

    #sunique(df[!, code])

    labels = string.(levels(df[!, thing]))
    elements = [PolyElement(polycolor = clrs[i+1]) for i in 1:length(labels)]

    ttl = replace(string(thing), "_" => " ")
    Legend(
        ll[1, 1], elements, labels, ttl,
        tellheight = false, tellwidth = false
    )

    colgap!(lo, 0)
    colsize!(lo, 1, colsize)
    ylims!(ax1, 0, 1)
    xlims!(ax1, extrema(df[!, unit])...)
    hidedecorations!(ax1, ticks = false, ticklabels = false, label = false)
    hidexdecorations!(ax1, label = false)

    return fg
end

export unitbarplot
