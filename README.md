# NiceDisplay.jl

After a particularly painful period of trial-and-error, I have come to prefer an analysis and presentation workflow that centers around [Quarto](https://quarto.org) but does not directly render code. I have found that it is slow, and difficult to format images nicely within code rendered in `.qmd` files. This especially true when working in Julia. Moreover, I do not want to frequently re-execute long-running code to render files. While they do cache, I actively despise working with Jupyter notebooks, which I find finicky and (again) slow. Moreover, evaluating Julia code in `.qmd` requires an intermediate pass through Jupyter.

Consequently, I write my code, generate my tables and figures (in what I can only assume is) old-fashioned way. I then load these into my `.qmd` document using `{{< include ... >}}` statements.

Here is a collection of functions that assist in producing figures (with [Makie.jl](https://docs.makie.org/stable/) in mind) and tables (using [PrettyTables.jl](https://ronisbr.github.io/PrettyTables.jl/stable/) and [TexTables.jl](https://jacobadenbaum.github.io/TexTables.jl/stable/)) with captions and tags that render to Markdown.
