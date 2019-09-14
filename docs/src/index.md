```@meta
CurrentModule = ScenTrees
```

# ScenTrees.jl

!!! info
	`ScenTrees.jl` is still under development.

`ScenTrees.jl` is a package for generating and improving scenario trees and scenario lattices for multistage stochastic optimization problems using _stochastic approximation_. In this library, we use a fixed number of trajectories of a stochastic process to generate and improve a scenario tree or a scenario lattice. The quality of approximation between the stochastic process and the scenario tree/ the scenario lattice is measure using a multistage distance. The resulting scenario tree/lattice is optimal and represents the stochastic process in the best possible way and so can be used for decision making process.

In these tutorials, we assume that the reader is quite familiar with the theory and explanation in the paper [Georg Ch. Pflug and Alois Pichler (2015)](https://doi.org/10.1007/s10589-015-9758-0).

## Installation

The library `ScenTrees.jl` is on the registration process and can be installed in Julia as follows:

```julia
]      # For the Pkg mode
add https://github.com/kirui93/ScenTrees.jl.git
```

Once you have ScenTrees.jl installed, we recommend that you have a look on the tutorials from the beginning to the end to understand on how you can use the package to do scenario tree/lattice generation by the stochastic approximation process.

## Citing `ScenTrees.jl`

!!! info
	To be added.

