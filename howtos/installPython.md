---
title: Installing Python
---

The focus of the course is Julia, but I plan to spend a small amount of time on the use of GPUs via Python. You can use Python through the SCF (and you'll need to do so for GPU access), but if you do want install Python on your own machine, here is some information

We recommend using the [Miniforge distribution](https://github.com/conda-forge/miniforge) as your Python 3.12 installation.

Once you've installed Python, please install the following packages: 

- numpy
- scipy
- pandas
- jax
- pytorch


Assuming you installed Miniforge, you should be able to do this from the command line:

```
conda install -c conda-forge numpy scipy pandas jax
conda install pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia
```
