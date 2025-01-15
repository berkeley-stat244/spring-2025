---
title: Accessing Julia
---

## Installing and Accessing Julia

Julia should be straightforward to [install on your own computer](https://julialang.org/downloads/).

Julia is also available on all the SCF machines. If you're in a shell/terminal, you'll first need to run `module load julia`. 

## Using Julia packages

One gets access to a Julia package using `using <packageName>` (or `import <packageName`).

If the package is not part of your project (all Julia work is done in a project), you'll need to add it like this, using the `BenchmarkTools` package as an example:

```julia
using Pkg
Pkg.add("BenchmarkTools")
```

If the package is not installed on the machine, Julia will prompt you to install it. Packages will generally be installed in `~/.julia/packages` (where `~` is shorthand for the location of your home directory).

## Using Julia in Jupyter notebooks

To use Julia in a notebook on the SCF JupyterHub, you can just select Julia as the kernel from the dropdown in the top right.

To use Julia in a notebook on your own machine, you need to install the Julia kernel for Jupyter.

```julia
using Pkg
Pkg.add("IJulia")
installkernel("Julia")
```

That should create a kernel called "Julia" that you can select as the kernel when you are in a Jupyter notebook.
