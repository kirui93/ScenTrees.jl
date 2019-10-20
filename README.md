# ScenTrees.jl

[![Build Status](https://travis-ci.com/kirui93/ScenTrees.jl.svg?branch=master)](https://travis-ci.com/kirui93/ScenTrees.jl)
[![Coverage](https://codecov.io/gh/kirui93/ScenTrees.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/kirui93/ScenTrees.jl)
[![Documentation](https://img.shields.io/badge/dos-latest-blue.svg)](https://kirui93.github.io/ScenTrees.jl/latest/)

`ScenTrees.jl` is a package for generating and improving scenario trees and scenario lattices for multistage stochastic optimization problems using _stochastic approximation_. 

Here is the [documentation](https://kirui93.github.io/ScenTrees.jl/latest/). This documentation gives a brief description of what the package does and also gives a detailed view on how to use the package to generate scenario trees and scenario lattices. It would be good, as a user, to go through this documentation to get an oversight of the package.

`ScenTrees.jl` library follows the stochastic approximation framework provided by [Pflug and Pichler(2015)](https://doi.org/10.1007/s10589-015-9758-0). This package is actively developed; new improvements and new features are continuously added.

The following shows an example of approximating a Gaussian random walk process using a scenario tree with 1x3x3x3x3 branching structure and 1-dimensional state space of the nodes in the scenario tree. The scenario tree on the right approximates the Gaussian random walk on the left. The multistage distance between the two stochastic processes is `0.11355`. Generally, we minimize the multistage distances between the stochastic processes and therefore a smaller the multistage distance between the two stochastic processes means that the scenario tree or the scenario lattice better approximates the stochastic process.

<p float="center">
  <img src="docs/src/assets/100GaussianPaths.png" width="380" />
  <img src="docs/src/assets/exampleTree1.png" width="380" /> 
</p>

We also provide a method for generating samples from observed trajectories using the `kernel density estimation`. Given a data, our function takes the data and through the conditioanl density estimation and the composition method, the algorithm generates one trajectory for each call. This trajectory is fed into the stochastic approximation algorithm to generate a scenario tree or a scenario lattice for a specified number of iterations.

If you need help or any questions regarding the library and any suggestions, file a new Github issue on https://github.com/kirui93/ScenTrees.jl/issues/new. 
