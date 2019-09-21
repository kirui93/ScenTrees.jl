```@meta
CurrentModule = ScenTrees
```

# Introduction

In multistage stochastic optimization, we are interested in approximations of stochastic processes by finite structures. These processes are random and they have uncertain scenarios and a decision maker needs to make decisions at different stages of the process. It is useful to depict the possible sequences of data for this processes in form of a `scenario tree` in the case of a discrete time stochastic process and a `scenario lattice` for Markovian data processes.

A scenario tree/lattice is organized in levels which corresponds to stages ``1,\ldots,T``. Each node in a stage has a specified number of predecessors as defined by the branching structure. A node represents a possible state of the stochastic process and the vertices represents the possibility of transition between the two connected nodes. A scenario tree differs from a scenario lattice by the condition that each node in stage ``t`` must have one predecessor in stage ``t-1``. For a lattice, that is not the case; all the nodes in stage ``t-1`` share the same children in stage ``t``.

## Goal

The goal  of `ScenTrees.jl` is to generate a valuated probability tree or a lattice which represents the stochastic process in the best way possible. 

For example, consider a Gaussian random walk in 5 stages. The starting value of this process is known and fixed, say at ``0`` and the other values are random. The following plot shows 100 sample paths of this process:

![100 sample paths from Gaussian random walk](../assets/100GaussianPaths.png)

Using those paths, we generate and improve a scenario tree or a scenario lattice. The number of iterations for the algorithm equals the number of sample paths that we want to generate from the stochastic process and the number of stages in the stochastic process equals the number of stages in the scenario tree or the scenario lattice. There are a lot of different branching structures that the user can choose for a tree that represents this stochastic process. The branching structure shows how many branches each node in the tree has at each stage of the tree. For example, we can use a branching structure of `1x2x2x2x2` for the scenario tree. This means that each node in the tree has two children. Basically, this is a `binary tree`. Using this branching structure, we obtain the following valuated probability tree that represents the above stochastic process:

![Scenario Tree 1x2x2x2x2](../assets/TreeExample.png)

*Figure 1: Scenario Tree 1x2x2x2x2*

The above tree is optimal and therefore can be used by a decision maker for a decision making process depending on the type of problem he/she is handling.

To measure the quality of the approximation, we use the concept of multistage distance between the stochastic process and the scanario tree or lattice.

### Multistage distance

To measure the distance of stochastic processes, it is not sufficient to only consider the distance between thier laws. It is also important to consider the information accumulated over time i.e., what the filtrations has to tell us over time. The Wasserstein distance do not correctly separate stochastic processes having different filtrations. It ignores filtrations and hence does not distinguish stochastic processes.

Multistage distance was introduced by [Georg Ch. Pflug (2009)](https://doi.org/10.1137/080718401). It turns out that this distance is very important to measure the distence between multistage stochastic processes as it incorporates filtrations introduced by the processes. We use this distance in our algorithm to measure the quality of approximation of the scenario tree. Generally, a scenario tree with a minimal distance to the stochastic process is consider to have a better quality approximation.

## Description of a scenario tree

A scenario tree is described by the following:

1. Name of the tree
2. Parents of the nodes in the tree
3. Children of the parents in the tree 
4. States of the nodes in the tree
5. Probabilities of transition from one node to another.

A scenario tree is a mutable struct of type `Tree()`. To create a non-optimal scenario tree, we need to fix the branching structure and the dimension of the states of nodes you are wroking on. This typs `Tree()` has different methods:
```julia
julia> using Pkg
julia> Pkg.add("https://github.com/kirui93/ScenTrees.jl.git")
julia> using ScenTrees
julia> methods(Tree)
# 4 methods for generic function "(::Type)":
[1] Tree(name::String, parent::Array{Int64,1}, children::Array{Array{Int64,1},1}, state::Array{Float64,2}, probability::Array{Float64,2}) 
[2] Tree(identifier::Int64) 
[3] Tree(spec::Array{Int64,1}) 
[4] Tree(spec::Array{Int64,1}, dimension) 
```
All the methods correspond to the way you can create a scenario tree. For the first method, the length of states must be equal to the length of the probabilities. In the 2nd method, you can call any of our predefined trees by just calling on the identifier (these identifiers are `0,301,302,303,304,305,306,307,401,402,4022,404,405`). And finaly the most important methods are the 3rd and 4th method. If you know the branching structure of your scenario tree, then you can create an non-optimal starting tree using it. If you don't state the dimension you ae working on, then it is defaulted into `1`. For example, `Tree([1,2,2,2,2])` creates a binary tree with states of dimension one as in Figure 1 above

## Description of a scenario lattice

A scenario lattice differs from a scenario tree in that every node in stage `t` is a child for each node in stage `t-1`. So the nodes in stage `t-1` share the same children.

Due to the above, we only describe a scenario lattice by:

1. Name of the lattice
2. States of the nodes of the lattice
3. Probabilities of transition from one node to another in the lattice

A scenario lattice has only one method.
```julia
julia> methods(Lattice)
 1 method for generic function "(::Type)":
[1] Lattice(name::String, state::Array{Array{Float64,2},1}, probability::Array{Array{Float64,2},1})
```
This method is not very important becasue we only need it to produce the results of the lattice approximation process. We will see later that for lattice approximation, we need the branching structure and so the structure of the lattice is not very important as in the case of a scenario tree.

## Usage
Since we have the basics of the scenario tree and the scenario lattice and since we created `ScenTrees.jl` with an intention of being user-friendly, we will give an example of its usage and explain each part of it. 
In the module of `ScenTrees.jl`, we have all the exported functions that are visible to the user i.e., that are public, and the user can call these functions depending on what he/she wants to achieve with this library

```julia
module ScenTrees
  include("TreeStructure.jl")
  include("TreeApprox.jl")
  include("StochPaths.jl")
  include("LatticeApprox.jl")
  include("bushinessNesDistance.jl")
  export TreeApproximation!, LatticeApproximation,Tree,Lattice,nodes,stage,height,leaves,
        root,partTree,buildProb!,treeplot,plotD,PlotLattice,bushinessNesDistance,
        GaussianSamplePath1D,GaussianSamplePath2D,RunningMaximum1D,RunningMaximum2D,path
end
```
The most important functions in this module are `TreeApproximation!()` and `LatticeApproximation()` since these are the two functions which are used to approximate scenario trees and scenario lattices respectively. The other important function is the `Tree(BranchingStructure,dimension)` function which gives the basic starting structure of a scenario tree.

All of the above functions have been documented in their respective scripts and the user can find out what each function does by putting a `?` before the function. For example, `?leaves` will give an explanation of what the function `leaves` does. 

In the upcoming tutorials, we will have a look in detail on the functionalities of the main functions of this library.
