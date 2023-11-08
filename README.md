# NiceDisplay.jl

After a particularly painful period of trial-and-error, I have come to prefer an analysis and presentation pipeline that centers around [Quarto](https://quarto.org) but does not use it to render code directly. I have found that it is slow, and difficult to format images nicely within code rendered in `.qmd` files. This especially true when working in Julia. Moreover, I do not want to frequently re-execute long-running code to render files. While they do cache, I actively despise working with Jupyter notebooks[^rdme-1], which I find finicky, opaque, and (again) slow. There are also questions about their [ease of replicability](https://arxiv.org/abs/2209.04308). Moreover, evaluating Julia code in `.qmd` requires an intermediate pass through Jupyter.

Consequently, I write my code, generate my tables and figures in (what I can only assume is) the old-fashioned way. I then load these into my `.qmd` document using `{{< include ... >}}` statements.

Here is a collection of functions that assist in producing figures (with [Makie.jl](https://docs.makie.org/stable/) in mind) and tables (using [PrettyTables.jl](https://ronisbr.github.io/PrettyTables.jl/stable/) and [TexTables.jl](https://jacobadenbaum.github.io/TexTables.jl/stable/)) with captions and tags for Markdown.

Produce and export a figure:

```julia
fg, ax, pl = scatter(x, y)

# default figure tag is the filename without suffix, e.g., {#fig-[filename]}
projectpath = "myrepo/"
dir = "figures/"
filename = "myfig"
caption = "Many things are illustrated in panels A-Z."
savemdfigure(
    projectpath, dir, filename, caption, fg;
    figuretag = nothing, type = ".svg"
);
```



[^rdme-1]: Apparently, there are [dozens of us](https://youtu.be/7jiPeIFXb6U?si=36nUdKpSboGvPG3U) who feel this way.