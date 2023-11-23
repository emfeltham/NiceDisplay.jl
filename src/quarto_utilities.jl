# quarto_utilities.jl
# utilities for converting julia objects to plots with captions and
# markdown tables, etc.

"""
        savemdfigure(projectpath, dir, filename, caption, figure;
                    tag = nothing, type = ".svg")

Save figure and generate markdown script for a figure, with caption and, additional properties (tag). fnp: file path to figure, fp: file path to figure without extension ("_cap.txt" is added).

Tag is prefixed for a figure ('#fig-').
"""
function savemdfigure(
    projectpath, dir, filename, caption, figure;
    tag = nothing, type = ".svg"
)

    if isnothing(tag)
        tag = filename
    end

    saveloc = projectpath * dir * filename
    save(saveloc * type, figure)
    figloc = dir * filename * type
    mdfigure(saveloc, figloc, "#fig-" * tag, caption)
end

export savemdfigure

"""
        mdfigure(saveloc, dir, filename, tag, cap)

Generate markdown script for a figure, with caption and, additional properties (tag). fnp: file path to figure, fp: file path to figure without extension ("_cap.txt" is added).
"""
function mdfigure(saveloc, figloc, tag, cap)

    a = "!" * "[" * cap * "]" * "(" * figloc * ")" * "{"*tag*"}"
    open(saveloc * "_cap.txt", "w") do file
        write(file, a)
    end
end

export mdfigure

"""
        savemddf(
            directory, filename, caption, df;
            tag = nothing, truncate = 32,
            vlines = :all, tf = PrettyTables.tf_markdown
        )

Convert DataFrame to MarkDown and save as a .txt file with caption (`caption`) and properties (`tag`).
"""
function savemddf(
    directory, filename, caption, df;
    tag = nothing, truncate = 32,
    vlines = :all,
    opts = nothing,
    tf = PrettyTables.tf_markdown
)

    if isnothing(tag)
        tag = filename
    end

    opts = if isnothing(opts)
        ""
    else
        " " * opts
    end

    a = " {#tbl-" * tag * opts * "}"
    open(directory * filename * ".txt", "w") do file
        show(
            file, df;
            summary = false,
            eltypes = false,
            vlines = vlines,
            truncate = truncate,
            tf = tf
        )
        write(file, "\n \n")
        write(file, ": " * caption * a)
    end
end

export savemddf
