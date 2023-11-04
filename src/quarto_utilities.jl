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
        mddf(df, cap, filename, path; tag = nothing)

Convert DataFrame to MarkDown and save as a .txt file with caption (`cap`) and properties (`tags`).
"""
function mddf(df, cap, filename, path; tag = nothing)

    if isnothing(tag)
        tag = filename
    end

    a = " {" * tag * "}"
    open(path * filename * ".txt", "w") do file
        show(
            file, df;
            summary = false,
            eltypes = false,
            vlines = :all,
            tf = PrettyTables.tf_markdown
        )
        write(file, "\n \n")
        write(file, ": " * cap * a)
    end
end

export mddf
