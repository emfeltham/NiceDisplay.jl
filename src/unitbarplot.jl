# hhbarplot.jl

"""
        unitbarplot(
            hh, thing; wave = nothing, prop = true, unit = :village_code,
            dosort = true, rev = false
        )

By-unit stacked barplot for distribution of binary- and categorical-valued `thing`.

`dosort`: if `false`, units will be sorted according to their alphanumeric order, if `true` units will be sorted in order of decreasing category frequency (e.g., first by the most common value, second by the second most common value...) either count or proportion depending on the value of `prop`."
"""
function unitbarplot(
    dfin, thing;
    wave = nothing, prop = true, unit = :village_code, 
    clrs = colorschemes[:tol_light],
    colsize = Relative(2/3),
    dosort = true, rev = false
)

    df = deepcopy(dfin)

    df[!, unit] = levelcode.(df[!, unit]);

    code = :code
    if nonmissingtype(eltype(df[!, thing])) == Bool
        df[!, thing] = categorical(string.(df[!, thing]))
    end;
    replace!(df[!, thing], missing => "missing");
    
    if !isnothing(wave)
        @subset! df :wave .== wave
    end

    vr = if prop
        :prop
    else
        :n
    end

    df = @chain df begin
        groupby([unit, thing])
        combine(nrow => :n)
        groupby(unit)
        DataFramesMeta.transform(:n => sum)
        @transform(_, :prop = :n ./ :n_sum)
        dropmissing()
    end

    if dosort
        thingsort = @chain df begin
            groupby(thing)
            combine(vr => mean => vr)
            sort(vr; rev = true)
        end
        thingsort = string.(thingsort[!, thing])

        sorder = @chain df begin
            unstack(unit, thing, vr)
            sort(thingsort; rev = rev)
        end
        sorder.col = 1:nrow(sorder)
        select!(sorder, [unit, :col]);

        leftjoin!(df, sorder, on = unit);
        df.idx = df.col
    else
        df.idx = df[!, unit]
    end
    
    df.code = CategoricalArrays.levelcode.(df[!, thing])

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
        ax1, df[!, :idx], df[!, vr],
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
