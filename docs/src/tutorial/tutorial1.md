# Introduction

Multistage stochastic optimization involves approximating a stochastic process in by a finite structure.
We call these structures a scenario tree and a scanrio lattice.
Scenario lattices plays an important role in approximating Markovian data processes.

We will look at the basic functionality of `ScenTrees.jl` just to highlight on how it works.

## Goal

The goal is to generate a valuated probability tree or a lattice which represents the stochastic process in the best way possible.

To measure the quality of the approximation, we use a process distance between the stochastic process and the scanario tree or lattice.

## Description of a scenario tree

A scenario tree is characterized by the following:

1. Name of the tree
2. Parents of the nodes in the tree
3. Children of the parents in the tree 
4. States of the nodes in the tree
5. Probabilities of transition from one node to another.

The tree is also characterized by its _nodes_, _stages_, _height_,_leaves_ and the _root_ of the tree or the nodes.

Each tree has stages starting from `0` where the root node is. 

## Description of a scenario lattice

A scenario lattice differs from a scenario tree in that every node in stage `t` is a child for each node in stage `t-1`. So the nodes in stage `t-1` share the same children.

Due to the above, we only describe a scenario lattice by:

1. Name of the lattice 
2. States of the nodes of the lattice
3. Probabilities of transition from one node to another in the lattice

# Usage

Since we have the basics of the scenario tree and the scenario lattice and since we created `ScenTrees.jl` 
with an intention of being user-friendly, we will give an example of its usage and explain each part of it.

```julia
using ScenTrees

ex1 = Tree([1,3,3,3,3]);
sol1 = TreeApproximation!(ex1, GaussianSamplePath, 100000,2,2);

treeplot(sol1)
```
In the above, we are creating a scenario tree with the branching structure `1x3x3x3x3` as `ex1`. 
We want to approximate the Gaussian random walk with this tree.
So, the tree approximation process takes 4 inputs:

1. A tree
2. The process to be approximated
3. Sample size
4. Which norm (default to Euclidean norm = 2)
5. The value of `r` for process distance ( default to `r=2`)

Those are basically the inputs that we are giving to the function _TreeApproximation!_. 
What we obtain as a result of this is a valuated tree which can be visualized by the function _treeplot_ or _plotD_ if incase you were dealing with a 2-dimensional state space.

![Stochastic approximation](../assets/exampleTree1.png)

Just as easy as that! 

It is more even simple for lattice approximation as in this we only take as inputs the branching structure of the lattice and the sample size as follows:

```julia
sol2 = LatticeApproximation([1,2,3,4,5], 500000)

PlotLattice(sol2)
```

# Plotting

As shown in the above, there are three different functions for plotting. We have _treeplot_, _plotD_ and _PlotLattice_ functions. 
Each of these functions is special in its own way. Both _treeplot_ and _plotD_ are for plotting scenario trees while _PlotLattice_ is only for plotting lattice.
In this package, we deal also with trees of 2D state space. So you can visualize them after approximation using _plotD_ function. 
So the main difference between _treeplot_ and _plotD_ is that  _treeplot_ is for trees only in 1D state space while _plotD_ can be used for trees in 1D and 2D but specifically created for trees in 2D state space.

!!! info
	You need to install the [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl) package for this plots.

You can save the plots using the the `Plots.jl` function `savefig`:
```julia
Plots.savefig("example1.pdf")
```

This ends the tutorial for this package.
