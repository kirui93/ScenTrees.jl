# ScenTrees.jl

[![Build Status](https://travis-ci.com/kirui93/ScenTrees.jl.svg?branch=master)](https://travis-ci.com/kirui93/ScenTrees.jl)
[![Coverage](https://codecov.io/gh/kirui93/ScenTrees.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/kirui93/ScenTrees.jl)
[![Documentation](https://img.shields.io/badge/dos-latest-blue.svg)](https://kirui93.github.io/ScenTrees.jl/latest/)

`ScenTrees.jl` is a Julia library for generating and improving scenario trees and scenario lattices for multistage stochastic optimization problems using _stochastic approximation_. 

The documentation can be found at https://kirui93.github.io/ScenTrees.jl/latest/. Here you can get the description of the various functions in the package and also different examples for the different features in the library.

`ScenTrees.jl` library follows the stochastic approximation framework provided by [Pflug and Pichler(2015)](https://doi.org/10.1007/s10589-015-9758-0). 

This package is actively developed and therefore new improvements and new features are continuously added.

We provide two important features at the moment:

    1. Stochastic approximation of stochastic processes.
    2. Estimating trajectories from data using kernel density estimation.

If you need help or any questions regarding the library and any suggestions, file a new Github issue at https://github.com/kirui93/ScenTrees.jl/issues/new. 
