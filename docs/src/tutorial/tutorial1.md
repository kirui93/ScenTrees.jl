```@meta
CurrentModule = ScenTrees
```

# Introduction

In multistage stochastic optimization, we are interested in approximations of  stochastic processes in by a finite structures. These processes are random and they have uncertain scenarios and a decesion maker needs to make decisions at different stages. It is useful to depict the possible sequences of data for this processes in form of a `scenario tree` in the case of a discrete time stochastic process and a `scenario lattice` for Markovian data processes.

A scenario tree/lattice is organized in levels which corresponds to stages ``1,\ldots,T``. Each node in a stage has a specified number of predecessors as defined by the branching structure.

## Goal

The goal is to generate a valuated probability tree or a lattice which represents the stochastic process in the best way possible.

To measure the quality of the approximation, we use a process distance between the stochastic process and the scanario tree or lattice.

`ScenTrees.jl` was developed with the above goal in mind. 

## Description of a scenario tree

A scenario tree is characterized by the following:

1. Name of the tree
2. Parents of the nodes in the tree
3. Children of the parents in the tree 
4. States of the nodes in the tree
5. Probabilities of transition from one node to another.


## Description of a scenario lattice

A scenario lattice differs from a scenario tree in that every node in stage `t` is a child for each node in stage `t-1`. So the nodes in stage `t-1` share the same children.

Due to the above, we only describe a scenario lattice by:

1. Name of the lattice
2. States of the nodes of the lattice
3. Probabilities of transition from one node to another in the lattice

# Usage

Since we have the basics of the scenario tree and the scenario lattice and since we created `ScenTrees.jl` 
with an intention of being user-friendly, we will give an example of its usage and explain each part of it.