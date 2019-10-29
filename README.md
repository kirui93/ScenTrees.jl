
[![Build and Test Status](https://travis-ci.com/kirui93/ScenTrees.jl.svg?branch=master)](https://travis-ci.com/kirui93/ScenTrees.jl)
[![Coverage](https://codecov.io/gh/kirui93/ScenTrees.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/kirui93/ScenTrees.jl)
[![Documentation](https://img.shields.io/badge/dos-latest-blue.svg)](https://kirui93.github.io/ScenTrees.jl/latest/)

# ScenTrees.jl

`ScenTrees.jl` is a Julia library for generating and improving scenario trees and scenario lattices for multistage stochastic optimization problems using _stochastic approximation_. It is totally written in Julia programiing language. This package provides functions for generating scenario trees and scenario lattices from stochastic processes and stochastic data.

We provide two important features at the moment:

- Stochastic approximation of stochastic processes by scenario trees and scenario lattices
- Estimating trajectories from stochastic data using kernel density estimation.
    
The data estimated in (2) above can be used in (1) to generate scenario trees and scenario lattices.

The stochastic approximation procedure in `ScenTrees.jl` library follows from the framework provided by [Pflug and Pichler(2015)](https://doi.org/10.1007/s10589-015-9758-0).

This package is actively developed and therefore new improvements and new features are continuously added.
## Installation
To use `ScenTrees.jl`, you need to have Julia 1.0 and above. This library has been tested for Julia 1.0,1.1,1.2 and nightly ( latest development). 

1. From Julia REPL, enter the pkg mode by pressing ```]``` 
2. Run the command ```add "https://github.com/kirui93/ScenTrees.jl.git"```.
    
Having done the above procedure, you can now just load the library using the normal procedure.

## Documentation 
If you have installed ScenTrees.jl using the above procedure then you will have the latest release of this library. To access the documentation just click on this link https://kirui93.github.io/ScenTrees.jl/latest/. Here you can get the description of the various functions in the package and also different examples for the different features in the library. We advise the user to read the documentation to get a general knowledge of how the package works and the various functions that this package provides. 

## Contributing to ScenTrees.jl
If you believe that you have found any bugs or if you need help or any questions regarding the library and any suggestions, please feel free to file a new Github issue at https://github.com/kirui93/ScenTrees.jl/issues/new. You can also raise an issue and issue a pull request which fixes the issue as long as it doesn't affect the performance of this library.

## References
+ Pflug, Georg Ch., and Alois Pichler, 2012. *A distance for Multistage Stochastic Optimization Models*. SIAM Journal on Optimization 22(1) doi: https://doi.org/10.1137/110825054
+ Pflug, Georg Ch., and Alois Pichler,2015. *Dynamic Generation of Scenario Trees*. Computational Optimizatio and Applications 62(3): doi: https://doi.org/10.1007/s10589-015-9758-0
+ Pflug, Georg Ch., and Alois Pichler,2016. *From Empirical Observations to Tree Models for Stochastic Optimization : Convergence Properties : Convergence of the Smoothed Empirical Process in Nested Distnce.* SIAM Journal on Optimization 26(3). Society for Industrial and Applied Mathematics (SIAM). doi: https://doi.org/10.1137/15M1043376.
