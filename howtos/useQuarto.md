---
title: Using Quarto
---

Quarto is a system for publishing technical content. We'll use with source files written in the Quarto flavor of Markdown, which can include mathematical notation using LaTeX syntax and code chunks that are evaluated during the publishing process. One then "renders" the source file into either HTML or PDF.

## Installing and using Quarto 

Unless you plan to generate your problem set solutions on the SCF, you'll need to [install Quarto](https://quarto.org/docs/get-started/).

Once installed, you should be able to run commands such as `quarto render FILE` and `quarto preview FILE` from the command line.

To render to PDF, you'll need a LaTeX engine installed. A good minimal solution if don't already have LaTeX installed (e.g., via MicTeX in Windows or MacTeX on MacOS) is to install `tinytex`: `quarto install tinytex`.

Quarto also runs from the Windows Command shell or PowerShell. 

`quarto convert` converts back and forth between the Jupyter notebook (.ipynb) and Quarto Markdown (.qmd) formats. So if you prefer, you can develop in a notebook and then convert to qmd and then render to prepare a nice-looking PDF for problem set/project/presentation submission.

The Quarto manual has [more details on using Quarto specifically in the context of using Julia](https://quarto.org/docs/computations/julia.html).

### Example Quarto document

Here's example content of a Quarto document. The first part is the YAML header/metadata giving details of how the document should be processed.

```
---
title: "Problem Set 1 Solutions"
author: "Chris Paciorek"
date: "2025-01-21"
engine: knitr
---

Here's some math: $\int \pi(\theta)d\theta = 1$.

Here's a code chunk that is evaluated.

```{julia}
x = 3;
println("The result is $(x*7).")
```
```

More details are available in the [Quarto manual](https://quarto.org/docs/authoring/markdown-basics.html), including [options for controlling the output from code chunks](https://quarto.org/docs/computations/execution-options.html).

### Rendering engines

By default, Quarto uses Jupyter to process code chunks. While this generally works well, for Julia, I think that using the R-based `knitr` will be a better choice (e.g., the output from running code prints out more nicely). To do so, add `engine: knitr` to the YAML metadata at the top of the file, as shown in the example above (if you happen to have an `execute` stanza, you'll need to have `engine: knitr` nested within that stanza). For the `knitr` engine, you'll need to have R installed on your computer, with the `rmarkdown` R package installed. If you do want to use Jupyter, you will probably need to add `jupyter: julia` to the YAML metadata at the top of the file (`jupyter: julia-1.10` on the SCF), and you will need a the IJulia kernel installed -- see the [howto on accessing Julia](./accessJulia.html).

There is also now a Julia engine for Quarto. I think it has the same downside as the Jupyter engine (all chunk output is printed together after the code chunk and only the last output is printed automatically), but you can try it like this.

First, install the QuartoNotebookRunner Julia package:

```julia
]add QuartoNotebookRunner#main
```

Then put `engine: julia` in the YAML metadata at the top of your Quarto document.
