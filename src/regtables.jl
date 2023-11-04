# regtables.jl

using DataStructures:OrderedDict
import Distributions:FDist

function MMColumn(
    header, m::T;
    stats = (:N => Int∘nobs, "BIC" => bic),
    meta = (),
    randomcomp = (),
    stderror::Function=stderror, kwargs...
) where T <: MixedModel

    # Compute p-values
    pval(m) = ccdf.(FDist(1, dof_residual(m)),
                    abs2.(coef(m)./stderror(m)))

    #pval(m) = m.pvalues

    # Initialize the column
    col  = RegCol(header)

    # ct = DataFrame(coeftable(m))
    # Add the coefficients
    for (name, val, se, p) in zip(coefnames(m), coef(m), stderror(m), pval(m))
        setcoef!(col, name => (val, se))
        0.05 <  p <= .1  && star!(col[name], 1)
        0.01 <  p <= .05 && star!(col[name], 2)
        p <= .01 && star!(col[name], 3)
    end

    # VarCorr(m).σρ[1][1][1]
    for e in keys(VarCorr(m).σρ)
        setmeta!(col, e => VarCorr(m).σρ[e][1][1])
    end
    setmeta!(col, :Residual => m.σ)

    grps = ""
    for (i, x) in enumerate(m.reterms)
        if i == 1
            grps = grps * string(size(x, 2))
        else
            grps = grps * ", " * string(size(x, 2))
        end
    end
    setmeta!(col, :Groups => grps)

    # Add in the fit statistics
    setstats!(col, OrderedDict(p.first => p.second(m) for p in stats))

    # Add in the metadata
    setmeta!(col, OrderedDict(p.first=>p.second(m) for p in meta))
    setmeta!(col, :Estimator=> "MLE")

    return col
end

export MMColumn

function GLMColumn(
    header, m::T;
    stats = (:N => Int∘nobs, "BIC" => bic),
    meta = (),
    stderror::Function=stderror, kwargs...
) where T <: RegressionModel

    # Compute p-values
    pval(m) = ccdf.(FDist(1, dof_residual(m)),
                    abs2.(coef(m)./stderror(m)))

    #pval(m) = m.pvalues

    # Initialize the column
    col  = RegCol(header)

    # ct = DataFrame(coeftable(m))
    # Add the coefficients
    for (name, val, se, p) in zip(coefnames(m), coef(m), stderror(m), pval(m))
        setcoef!(col, name => (val, se))
        0.05 <  p <= .1  && star!(col[name], 1)
        0.01 <  p <= .05 && star!(col[name], 2)
        p <= .01 && star!(col[name], 3)
    end

    # Add in the fit statistics
    setstats!(col, OrderedDict(p.first => p.second(m) for p in stats))

    # Add in the metadata
    setmeta!(col, OrderedDict(p.first=>p.second(m) for p in meta))
    setmeta!(col, :Estimator=> "MLE")

    return col
end

export GLMColumn

## printing with PrettyTables.jl

function drawstars(n::Int)
    return if n == 0
        ""
    elseif n == 1
        "*"
    elseif n == 2
        "**"
    elseif n == 3
        "***"
    end
end

function pretty_reg(f,
    t1::T; backend = nothing, digits = 3, tf = nothing
) where T <: IndexedTable
    
    rwidx = t1.row_index;
    clidx = t1.col_index;

    rcols = [String[] for _ in clidx];
    rws = String[]
    brks = Int[]
    r1 = 1
    bcnt = 0

    icnt = 0
    for (i, ri) in enumerate(rwidx)
        icnt = i
        bcnt += 1
        push!(rws, string(ri.name[end]))
        if ri.idx[1] == 1 # if it is coef, make space for std. error
            push!(rws, "")
            bcnt += 1

            for (j, ti) in enumerate(t1.columns)
                # for each model included
                # ti.header
                vse = get(ti.data, ri, "")

                if vse == ""
                    push!(rcols[j], "")
                    push!(rcols[j], "")
                else
                    a = string(round(vse.val; digits = digits)) * drawstars(vse.star)
                    b = string(round(vse.se; digits = digits))
                    push!(rcols[j], a)
                    push!(rcols[j], "(" * b * ")")
                end
            end
        else
            (j, ti) = collect(enumerate(t1.columns))[1]
            for (j, ti) in enumerate(t1.columns)
                # for each model included
                # ti.header
                vse = get(ti.data, ri, "")
        
                if (vse == "")
                    push!(rcols[j], "")
                elseif (ismissing(vse.val))
                    push!(rcols[j], "")
                else
                    if typeof(vse.val) == Int
                        push!(rcols[j], string(vse.val))
                    elseif typeof(vse.val) <: AbstractFloat
                        a = string(round(vse.val; digits = digits))
                        push!(rcols[j], a)
                    else
                        push!(rcols[j], vse.val)
                    end
                end
            end
        end
        
        if r1 < ri.idx[1]
            push!(brks, bcnt-1)
        end

        r1 = ri.idx[1]
    end

    hdr = if any([length(e.name) for e in clidx] .> 1)
        hdr = ([""], [""])
        for e in clidx
            push!(hdr[1], string(e.name[1]))
            push!(hdr[2], string(e.name[2]))
        end
        hdr
    else
        hdr = [""]
        for e in clidx
            push!(hdr, string(e.name[1]))
        end
        hdr
    end


    rcmat = fill("", length(rcols[1]), length(rcols) + 1)
    rcmat[:, 1] = rws
    for i in eachindex(rcols)
        rcmat[:, i + 1] = rcols[i]
    end

    return if !isnothing(backend)
            pretty_table(
                rcmat;
                header = hdr,
                # body_hlines = brks,
                backend = Val(backend)
                # tf = tf_html_minimalist
            )
        else
            pretty_table(
                f,
                rcmat;
                header = hdr,
                body_hlines = brks, tf = tf
            )
        end
end

function pretty_reg(
    t1::T; backend = nothing, digits = 3, tf = nothing
) where T <: IndexedTable
    
    rwidx = t1.row_index;
    clidx = t1.col_index;

    rcols = [String[] for _ in clidx];
    rws = String[]
    brks = Int[]
    r1 = 1
    bcnt = 0

    icnt = 0
    for (i, ri) in enumerate(rwidx)
        icnt = i
        bcnt += 1
        push!(rws, string(ri.name[end]))
        if ri.idx[1] == 1 # if it is coef, make space for std. error
            push!(rws, "")
            bcnt += 1

            for (j, ti) in enumerate(t1.columns)
                # for each model included
                # ti.header
                vse = get(ti.data, ri, "")

                if vse == ""
                    push!(rcols[j], "")
                    push!(rcols[j], "")
                else
                    a = string(round(vse.val; digits = digits)) * drawstars(vse.star)
                    b = string(round(vse.se; digits = digits))
                    push!(rcols[j], a)
                    push!(rcols[j], "(" * b * ")")
                end
            end
        else
            (j, ti) = collect(enumerate(t1.columns))[1]
            for (j, ti) in enumerate(t1.columns)
                # for each model included
                # ti.header
                vse = get(ti.data, ri, "")
        
                if (vse == "")
                    push!(rcols[j], "")
                elseif (ismissing(vse.val))
                    push!(rcols[j], "")
                else
                    if typeof(vse.val) == Int
                        push!(rcols[j], string(vse.val))
                    elseif typeof(vse.val) <: AbstractFloat
                        a = string(round(vse.val; digits = digits))
                        push!(rcols[j], a)
                    else
                        push!(rcols[j], vse.val)
                    end
                end
            end
        end
        
        if r1 < ri.idx[1]
            push!(brks, bcnt-1)
        end

        r1 = ri.idx[1]
    end

    hdr = if any([length(e.name) for e in clidx] .> 1)
        hdr = ([""], [""])
        for e in clidx
            push!(hdr[1], string(e.name[1]))
            push!(hdr[2], string(e.name[2]))
        end
        hdr
    else
        hdr = [""]
        for e in clidx
            push!(hdr, string(e.name[1]))
        end
        hdr
    end


    rcmat = fill("", length(rcols[1]), length(rcols) + 1)
    rcmat[:, 1] = rws
    for i in eachindex(rcols)
        rcmat[:, i + 1] = rcols[i]
    end

    return if !isnothing(backend)
            pretty_table(
                rcmat;
                header = hdr,
                # body_hlines = brks,
                backend = Val(backend)
                # tf = tf_html_minimalist
            )
        else
            pretty_table(
                rcmat;
                header = hdr,
                body_hlines = brks, tf = tf
            )
        end
end

function pretty_reg(
    t1; backend = nothing, digits = 3
)
    rwidx = t1.row_index;
    clidx = t1.col_index;

    rcols = [String[] for _ in clidx];
    rws = String[]
    brks = Int[]
    r1 = 1
    bcnt = 0

    icnt = 0
    for (i, ri) in enumerate(rwidx)
        icnt = i
        bcnt += 1
        push!(rws, string(ri.name[end]))
        if ri.idx[1] == 1 # if it is coef, make space for std. error
            push!(rws, "")
            bcnt += 1

            for (j, ti) in enumerate(t1.columns)
                # for each model included
                # ti.header
                vse = get(ti.data, ri, "")

                if vse == ""
                    push!(rcols[j], "")
                    push!(rcols[j], "")
                else
                    a = string(round(vse.val; digits = digits)) * drawstars(vse.star)
                    b = string(round(vse.se; digits = digits))
                    push!(rcols[j], a)
                    push!(rcols[j], "(" * b * ")")
                end
            end
        else
            (j, ti) = collect(enumerate(t1.columns))[1]
            for (j, ti) in enumerate(t1.columns)
                # for each model included
                # ti.header
                vse = get(ti.data, ri, "")
        
                if (vse == "")
                    push!(rcols[j], "")
                elseif (ismissing(vse.val))
                    push!(rcols[j], "")
                else
                    if typeof(vse.val) == Int
                        push!(rcols[j], string(vse.val))
                    elseif typeof(vse.val) <: AbstractFloat
                        a = string(round(vse.val; digits = digits))
                        push!(rcols[j], a)
                    else
                        push!(rcols[j], vse.val)
                    end
                end
            end
        end
        
        if r1 < ri.idx[1]
            push!(brks, bcnt-1)
        end

        r1 = ri.idx[1]
    end

    hdr = if any([length(e.name) for e in clidx] .> 1)
        hdr = ([""], [""])
        for e in clidx
            push!(hdr[1], string(e.name[1]))
            push!(hdr[2], string(e.name[2]))
        end
        hdr
    else
        hdr = [""]
        for e in clidx
            push!(hdr, string(e.name[1]))
        end
        hdr
    end


    rcmat = fill("", length(rcols[1]), length(rcols) + 1)
    rcmat[:, 1] = rws
    for i in eachindex(rcols)
        rcmat[:, i + 1] = rcols[i]
    end

    return if !isnothing(backend)
            pretty_table(
                rcmat;
                header = hdr,
                # body_hlines = brks,
                backend = Val(backend)
                # tf = tf_html_minimalist
            )
        else
            pretty_table(
                rcmat;
                header = hdr,
                body_hlines = brks
            )
        end
end

export pretty_reg

function joinregs(ms; cnames = nothing)
    regs = Any[]

    nm = if isnothing(cnames)
        ["(" * string(i) * ")" for i in eachindex(ms)]
    elseif cnames == :depvar
        [string(m.formula.lhs) for m in ms]
    elseif typeof(cnames) == Vector{String}
        cnames
    else error("col names not specified correctly.")
    end
    
    for (i, m) in enumerate(ms)
        ttl = nm[i]
        vs = if typeof(m) <: MixedModel
            MMColumn(ttl, m)
        else
            GLMColumn(ttl, m)
        end
        push!(regs, vs)
    end
    return reduce(hcat, regs)
end

export joinregs

function processregs(m)
    return IndexedTable(MMColumn("", m))
end

function processregs(ms::T; cnames = nothing) where T <: Vector
    return joinregs(ms; cnames = cnames)
end

export processregs

"""
        exportregtable(projectpath, dir, filename, tbs, cap; tag = nothing)

Export regression models in markdown format to a -txt file with caption and
tag.
`tag` = nothing default gives tag based on filename.
"""
function exportregtable(projectpath, dir, filename, tbs, cap; tag = nothing)
    if isnothing(tag)
        tag = filename
    end
    path = projectpath * dir * filename
    open(path * ".txt", "w") do file
        pretty_reg(file, tbs; tf = tf_markdown)
        x = ": " * cap
        tag = " {#tbl-" * tag * "}"
        write(file, "\n \n")
        write(file, x * tag)
    end
end

export exportregtable
