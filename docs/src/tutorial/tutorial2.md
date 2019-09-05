```@meta
CurrentModule = ScenTrees
```

# Functions that describe a scenario tree

A basic scenario tree can be created using the `Tree` function in the package. This function takes the branching structure of the tree and the dimension that you are working on. For example, consider a tree with a branching structure of `1x2x2`. This is a tree with a root in stage `0`, and `2` nodes in stage 1 and each of the `2` nodes in stage one has `2` nodes in stage `2`.

```julia
julia> example1 = Tree([1,2,2],1)
Tree("Tree 1x2x2",[0,1,1,2,2,3,3],Array{Int64,1}[[1],[2,3],[4,5],[6,7]],[1.34897; 0.364954; -0.18401; 0.918859; -0.115944; 0.216302; 0.788106],[1.0; 0.3898; 0.6102; 0.4722; 0.5278; 0.4577; 0.5423])
```

The above tree is in 1 dimension. To generate a tree in 2 dimension, we use the following:

```julia
julia> Tree([1,2,2],2);
```
And in general, we can generate a tree in any `d` dimension.


The above tree can described by the following functions: _nodes_, _stages_, _height_, _leaves_ and the _root_ of the tree.

Each tree has stages starting from ``0`` where the root node is.

## Nodes of the tree

This are the vertices that are in the scenario tree. Each node in the tree has a parent node except the root node where the tree starts from. As stated before, each scenario tree is characterized by its name, parents of the nodes , children of each parent nodes e.t.c. So therefore, we have nodes which has parents and those nodes are the children of the parent nodes.

For example,

```julia
julia> nodes(example1)
1:7
```

## Stages of the tree

Each node in a tree is in a specific stage and nodes in the same stage have the same number of children. The stages in a tree starts from `0` where the root node is and ends at stage `T``where the leaf nodes are.

```julia
julia> stage(example1)
0
1
1
2
2
2
2
```

The above example shows that we have 1 node in stage 0, 2 nodes in stage 1 and 4 nodes in stage 2.

## Root of the tree

The root of the tree is the node in which the tree starts from. The root of the tree has no parent; more or less, is the parent of all nodes.

```julia
julia> root(example1)
1-element Array{Int64,1}
1
```

The function `root` can also give us a sequence of nodes to reach a particular node of the tree. It turns out that this function will be very important in stochastic approximation as it will give us a path that we can improve with samples from a stochastic process.

If we want a sequece of nodes to reach, for example, node 6 in the above tree, we just call out the `root``function as follows:

```julia
julia> root(example1,6)
3-element Array{Int64,1}
1
3
6
```

## Leaves of the tree

In each tree, we have the leaves. Leaves are all those in the tree which doesn't have children nodes. They are the terminal nodes in the tree. Our function `leaves` returns the leaf nodes in the tree, their indexes and the conditional probabilities to reach each of the leaves from the root node. Consider the following:

```julia
julia> leaves(example1)
([4,5,6,7],1:4,[0.2508,0.1709,0.2566,0.2508])
```

From the above, it is clear that the sum of the conditional probabilities to reach all the leaves in the tree is `1`.

## Plotting the tree

One of the most important things in programming is visualization. In this package, we can plot a scenario tree in 1D with the `treeplot` function and with the `plotD` function for a scenario tree in D dimension.

!!! info
	You need to install the [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl) package for this plots.
	

For example, we can plot a default tree already in the package and then the figure can be saved with the function `savefig`.

```julia
julia> treeplot(Tree(402))

julia> savefig("Tree402.pdf")
```

![Example of a tree in 1D](../assets/Tree402.pdf)

We can plot a tree in 2 dimension as follows:

```julia
julia> treeplot(Tree(4022))

julia> savefig("Tree4022.pdf")
```

![Example of a tree in 2D](../assets/Tree4022.pdf)