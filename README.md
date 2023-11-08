# NiceDisplay.jl

After a particularly painful period of trial-and-error, I have come to prefer an analysis and presentation pipeline that centers around [Quarto](https://quarto.org) but does not use it to render code directly. I have found that it is slow, and difficult to format images nicely within code rendered in `.qmd` files. This especially true when working in julia. Moreover, I do not want to frequently re-execute long-running code to render files. While they do cache, I actively despise working with Jupyter notebooks,[^rdme-1] which I find finicky, opaque, and (again) slow. There are also questions about their [ease of replicability](https://arxiv.org/abs/2209.04308). Moreover, evaluating julia code in `.qmd` requires an intermediate pass through Jupyter.

Consequently, I write my code, generate my tables and figures in (what I can only assume is) the old-fashioned way. I then load these into my `.qmd` document using `{{< include ... >}}` statements.

Here is a collection of functions that assist in producing figures (with [Makie.jl](https://docs.makie.org/stable/) in mind) and tables (using [PrettyTables.jl](https://ronisbr.github.io/PrettyTables.jl/stable/) and [TexTables.jl](https://jacobadenbaum.github.io/TexTables.jl/stable/)) with captions and tags for Markdown.

Produce and export a figure:

```julia
using CairoMakie, NiceDisplay

fg, ax, pl = scatter(x, y)

# The default figure tag is the filename without suffix, e.g., {#fig-[filename]}
projectpath = "myrepo/"
dir = "figures/"
filename = "myfig"
caption = "In panels A-Z, we can clearly see that this figure has too many panels."

# This saves the figure itself, and also a document, here "myfig_cap.txt" that includes the MarkDown text that loads the figure and also contains the caption and tag.
savemdfigure(
    projectpath, dir, filename, caption, fg;
    figuretag = nothing, type = ".svg"
);
```

"myrepo/figures/myfig_cap.txt":

```markdown
!["In panels A-Z, we can clearly see that this figure has too many panels."](myrepo/figures.svg){#fig-myfig}
```

The figure is incorporated into the working document as follows:

```markdown
This is the usual sort of text that fills a document. In particular, relevant to this context, it purports to describe @fig-myfig.

{{< include figures/myfig_cap.text >}}

More text follows.
```

The working document should be in "myrepo", so that the relative paths refer correctly.

[^rdme-1]: Apparently, there are [dozens of us](https://youtu.be/7jiPeIFXb6U?si=36nUdKpSboGvPG3U) who feel this way.
