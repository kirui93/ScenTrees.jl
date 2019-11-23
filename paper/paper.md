---
title: 'ScenTrees.jl: A Julia Package for Generating Scenario Trees and Scenario Lattices
  for Multistage Stochastic Programming'
tags:
  - Multistage Stochastic Programming
  - Scenario Trees
  - Scenario Lattices
  - Stochastic Processes
  - Julia
authors:
  - name: Kipngeno Kirui
    orcid: 0000-0002-3679-4442
    affiliation: "1"
  - name: Alois Pichler
    affiliation: "1"
    orcid: 0000-0001-8876-2429
  - name: Georg Ch. Pflug
    affiliation: "2"
affiliations:
  - name: University of Technology, Chemnitz, Germany
    index: 1
  - name: University of Vienna
    index: 2
date: 5 November, 2019
bibliography: paper.bib
---

# Summary

In multistage stochastic optimization we are interested in decision making under uncertainty. In this setting, stochastic processes have random and uncertain outcomes and decisions must be made at different stages of the process. It is generally intractable to solve mathematical programs with uncertain parameters described by an underlying probability distribution. The common approach is to form an approximation of the original stochastic process or underlying distribution by discretization. The procedure of discretizing a stochastic process is called `scenario tree generation`. We depict the possible sequences of data for this processes in form of a `scenario tree` in the case of a discrete time stochastic process and a ``scenario lattice`` for Markov processes.

Since the paper of @Hoyland2001, scenario tree generation has been used to solve various multistage stochastic problems in the industry and academia. Various authors including @Pflug2001, @KovacevicPichler and @PflugPichler2016 have come up to add and improve various ideas into the process of generating scenario trees. However, there is no fast and open-source implementation of the algorithm that has been available in the public domain for various users to appreciate. Instead, various researchers and industries have been forced to code their own implementations in a variety of languages they like themselves. This has limited many researchers and industries who would not like to code themselves from generating scenario trees with available implementations. Many researchers and industries also would not get the taste of comparing ideas against their own implementations and hence they may end up trusting their own results and implementations and maybe there is a better implementation.

The natural question when dealing with scenario generation for multistage stochastic optimization problems is how to approximate a continuous distribution of the stochastic process in such a way that the distance between the initial distribution and its approximation is minimized. We start with an initial scenario tree and use stochastic approximation to improve the values on the nodes of the tree. To quantify the quality of the approximation, we use process distance between the original process and the optimal scenario tree [@Pflug2009]. Process distance extends and generalizes the Wasserstein distance to stochastic processes. It was analyzed by @PflugPichler2011 and used by @KovacevicPichler directly to generate scenario trees.

Generally, we consider a stochastic process $X$ over a discrete time, i.e., $X = (X_0,X_1,\ldots,X_T)$ where $X_0$ is a deterministic. A scenario tree is a discrete time and discrete state process approximating the process $X$. We represent a scenario tree by $\tilde{X} = (\tilde{X}_0,\tilde{X}_1,\ldots,\tilde{X}_T)$.

A scenario tree is a set of nodes and branches used in models of decision making under uncertainty. Every node in a scenario tree represents a possible state of the stochastic process at a particular point in time and a position where a decision can be made. Each scenario tree node has only a single predecessor, but can have multiple successors. This makes the difference with scenario lattices since nodes of scenario lattices can have multiple predecessors. A scenario tree is organized in levels which corresponds to stages $(0,1,\ldots,T)$. Each node in a stage has a specified number of predecessors as defined by the branching structure of the scenario tree. An edge from a node indicates a possible realization of the uncertain variables from that state. The first node of a scenario tree is called the root node and the set of nodes in the last stage are called the leaves. Any possible path from the root node to any of the leaf nodes is called a `trajectory` (also called a `path` or a `scenario`).

`ScenTrees.jl` is a Julia [@JULIA2019] package for generating scenario trees and scenario lattices which can be used, for example, for multistage stochastic optimization problems. The theory and design of the `ScenTrees.jl` package follows Algorithm 5 in @PflugPichlerDynScenarioGen. The package's design allows us to obtain a fast code with high flexibility and excellent computational efficiency. The design choices were highly motivated by the properties of the Julia [@julia] language. It starts with a tree which is a qualified guess by the user or an expert opinion and iterates over the nodes of the tree updating them with scenarios drawn from a user-defined distribution. In this way, the approximating quality of the tree is improved for each scenario generated. The iteration stops when the predefined number of scenarios have been performed.

# Main features of the package

The stochastic approximation framework allows ``ScenTrees.jl`` to be generally applicable to any stochastic process to be approximated. The following are key features that ``ScenTrees.jl`` provides. Implementation details and examples of usage can be found in the software's documentation.^[Documentation: https://kirui93.github.io/ScenTrees.jl/latest]

1. `Generation of scenario trees and scenario lattices from stochastic processes using the stochastic approximation algorithm`: Here, the structure of the scenario tree or the scenario lattice is fixed in terms of the branching vector then stochastic approximation is used to improve the states of the nodes considering all the data available for every approximation. This improvement goes on until a pre-specified number of iterations have been performed and then the process distance is calculated.^[Tutorial4: https://kirui93.github.io/ScenTrees.jl/latest/tutorial/tutorial4/]

2. `Generation of scenarios based on data`: Here we have data from some observed trajectories of a scenario process with an unknown distribution and we employ conditional density estimation to generate new but different samples based on these trajectories. The new samples can then be used to generate scenario trees or scenario lattices using the stochastic approximation procedure as outlined in 1 above.^[Tutorial41: https://kirui93.github.io/ScenTrees.jl/latest/tutorial/tutorial41/]

# Example: Scenario generation from observed trajectories

We want to use the concept of density estimation and stochastic approximation to generate scenario trees and scenario lattices for a $(1000\times 5)$ dimensional data. The first step is to load the package and the data into Julia as follows:

```julia
# Load the package
julia> using ScenTrees
# Load the CSV data from a directory
julia> df = CSV.read("../RData.csv");
# Convert the DataFrame into a Matrix
julia> data = Matrix(df);                
```
The following shows an example of a trajectory generated from the data using conditional density estimation:
```julia
julia> Example = KernelScenarios(data, Logistic; Markovian=false)()
[1.5595,0.8150,1.5058,2.6475,4.6137]
```
The generated data has a length equal to the number of columns of the original data. These generated trajectories are the ones we use to approximate a scenario tree and a scenario lattice in the following subsections.

## Approximating with a scenario tree

Consider a scenario tree with a branching vector $[1,3,3,3,2]$. We approximate this process using $1,000,000$ iterations as follows:
```julia
julia> ApproxTree = TreeApproximation!(Tree([1,3,3,3,2],1),
                  KernelScenarios(data, Logistic; Markovian=false), 100000, 2, 2);
julia> treeplot(ApproxTree)
julia> savefig("ApproxTree.pdf")
```

![Tree Approximation from Kernel Density Samples](images/rwdataTree.pdf){height=250px}

The number of possible trajectories in the scenario tree equals its number of leaves. In the above scenario tree, there are $54$ possible trajectories as the number of leaves is $(1\times3\times3\times3\times2) = 54$. The algorithm returns the multistage distance between the above scenario tree and the original stochastic process as $d=0.23092$.

## Approximating with a scenario lattice

Consider a scenario lattice with a branching vector $(1,3,4,5,6)$. Clearly, this scenario lattice has $5$ stages as shown by the number of elements in the branching vector, which is equal to number of columns in the data. We consider $1,000,000$ iterations for the stochastic approximation algorithm.

```julia
julia> ApproxLattice = LatticeApproximation([1,3,4,5,6],
                       KernelScenarios(data, Logistic; Markovian=true), 1000000);
julia> PlotLattice(ApproxLattice)
julia> savefig("ApproxLattice.pdf")
```

![Lattice Approximation from Kernel Density Samples](images/rwdataLattice.pdf){height=250px}

The number of nodes in the scenario lattice is equal to the sum of elements in the branching structure, i.e., $1+3+4+5+6 = 19$ nodes. The scenario tree considered above has $94$ nodes and $54$ possible scenarios while the scenario lattice above has $19$ nodes and $(1\times2\times3\times4\times5) = 360$ scenarios. This shows generally with fewer number of nodes can have many possible trajectories than a scenario tree with more number of nodes. The algorithm returns the multistage distance between the above scenario lattice and the original process as $d=1.1718$.

# Acknowledgements

This work was supported by the German Academic Exchange Service (DAAD).

# References
