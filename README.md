# ScenTrees.jl

[![Build Status](https://travis-ci.com/kirui93/ScenTrees.jl.svg?branch=master)](https://travis-ci.com/kirui93/ScenTrees.jl)
[![Coverage](https://codecov.io/gh/kirui93/ScenTrees.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/kirui93/ScenTrees.jl)
[![Documentation](https://img.shields.io/badge/dos-latest-blue.svg)](https://kirui93.github.io/ScenTrees.jl/latest/)

`ScenTrees.jl` is a package for generating and improving scenario trees and scenario lattices for multistage stochastic optimization problems using _stochastic approximation_. The documentation can be found <a href="https://kirui93.github.io/ScenTrees.jl/latest/"> here </a>.

This package has three main functions:
  1. Provide a _fast_ and simple way to generate scenario trees and scenario lattices using the Julia framework.
  2. Generate and improve scenario trees from samples of a discrete-time and space non-Markovian process
  3. Generate and improve scenario lattices from samples of a Markovian data process.

The ScenTrees package follows the stochastic approximation framework provided by [Pflug and Pichler(2015)](https://doi.org/10.1007/s10589-015-9758-0). This package is actively developed and new features are continuously added.

If you need help or any questions regarding the library and any suggestions, file a Github issue on <a href="https://github.com/kirui93/ScenTrees.jl/issues/new"> this page </a>.
