```@meta
CurrentModule = ScenTrees
```

# ScenTrees.jl

!!! info
	`ScenTrees.jl` is an actively developed library and new features and improvements are continuously added.
	
## Features

1). `ScenTrees.jl` is a package for generating and improving scenario trees and scenario lattices for multistage stochastic optimization problems using _stochastic approximation_. In this library, we use a fixed number of trajectories of a stochastic process to generate and improve a scenario tree or a scenario lattice. The quality of approximation between the stochastic process and the scenario tree/ scenario lattice is measured using a multistage distance. The multistage distance suits well to measure the distance between stochastic processes because it takes notice of the effect of evolution of the process over time (Have a look on [Georg Ch. Pflug and Alois Pichler(2012)](https://doi.org/10.1137/110825054) for more on distances for multistage stochastic optimization models). The resulting scenario tree/lattice from the stochastic approximation process is optimal and represents the stochastic process in the best possible way and so can be used for decision making process under uncertainty.

2). We also provide the user with one of the methods of generating trajectories from an array of data. This method takes two steps: First, we use the conditional density estimation to genrate new but different samples based on the data given. Here we estimate the distribution of transitional densities given the history of the process via the non-parametric kernel distribution. Finally, we use the composition method to sample from the above distribution. The trajectory created in this process can then ne used in the stochastic approximation algorithm to generate a scenario lattice for multistage stochastic approximation. We urge the reader to have a look at [Georg Ch. Pflug and Alois Pichler(2016)](https://doi.org/10.1137/15M1043376), [Georg Ch. Pflug and Alois Pichler(2015)](https://doi.org/10.1007/s10589-015-9758-0) and [Seguin Sara et.al(2017)](https://doi.org/10.1016/j.ejor.2016.11.028) to get a glimpse of how this method works.

In these tutorials, we assume that the reader is quite familiar with the theory and explanation of the stochastic approximation algorithm in this paper [Georg Ch. Pflug and Alois Pichler(2015)](https://doi.org/10.1007/s10589-015-9758-0). 

## Installation

The library `ScenTrees.jl` is on the registration process and can be installed in Julia as follows:

```julia
julia> using Pkg
julia> Pkg.add("https://github.com/kirui93/ScenTrees.jl.git")
julia> using ScenTrees
```

Once you have ScenTrees.jl installed, we recommend that you have a look on the tutorials from the beginning to the end to understand on how you can use the package to do scenario tree/lattice generation by the stochastic approximation process.

## Citing `ScenTrees.jl`

For all the users of this library, we request that they cite the following paper in their publications:

!!! info
	To be added.

