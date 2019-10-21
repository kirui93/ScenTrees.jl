---
title: 'ScenTrees.jl---A Julia Library for Generating Scenario Trees and Scenario Lattices
  for Multistage Stochastic Programming'
tags: 
  - Multistage Stochastic Programming
  - Scenario Trees
  - Scenario Lattices
  - Stochastic Processes
  - Julia
authors:
  - name: Kipngeno Kirui, 
    orcid: 0000-0002-3679-4442
    affiliation: 1
    email: kipngenokirui@s2019.tu-chemnitz.de
  - name: Alois Pichler
    affiliation: 1
    email: alois.pichler@math.tu-chemnitz.de
  - name: Georg Ch. Pflug
    affiliation: 2
    email: georg.pflug@univie.ac.at
affiliations:
  - name: Technical University of Chemnitz
    index: 1
  - name: University of Vienna
    index: 2
date: \today
bibliography: paper.bib
---

# Summary

We present ``ScenTrees.jl``, an open source library for generating scenario trees and scenario lattices for multistage stochastic optimization. Our goal is to construct a valuated scenario tree or scenario lattice from observed sample stochastic paths using stochastic approximation. The algorithm takes a scenario tree/lattice and gradually improves it with samples from a stochastic process following a user defined procedure. We also use the concept of process distance to measure the approximating quality of the scenario tree/lattice.

# General Description

In multistage stochastic optimization we are interested in approximations of stochastic processes. These processes are random and they have uncertain scenarios and decisions should be made at different stages of the process. It is useful to depict the possible sequences of data for this processes in form of a ``scenario tree`` in the case of a discrete time stochastic process and a ``scenario lattice`` for Markovian data processes. A scenario tree is organized in levels which corresponds to stages $0,1,\ldots,T$. Each node in a stage has a specified number of predecessors as defined by the branching structure of the scenario tree. 

Since the paper of @Hoyland2001, scenario tree generation has been used to solve various multistage stochastic problems in the industry and academia. Various authors including @Pflug2001, @KovacevicPichler, @PflugPichlerDynScenarioGen and @PflugPichler2016 have come up to add and improve various ideas into the process of generating scenario trees. However, there is no fast and open-source implementation of the algorithm that has been available in the public domain for various users to appreciate. Instead, various researchers and industries have been forced to code their own implementations in a variety of languages they like themselves. This has limited many researchers and industries who would not like to code themselves from generating scenario trees with available implementations. Many researchers and industries also would not get the taste of comparing ideas against their own implementations and hence they may end up trusting their own results and implementations and maybe there is a better implementation. 

The natural question when dealing with scenario generation for multistage stochastic optimization problems is how to approximate a continuous distribution of the stochastic process in such a way that the distance between the initial distribution and its approximation is minimized. We start with a scenario tree with random values and use stochastic approximation to improve the scenario tree. To quantify the quality of the approximation, we use the process distance between the original process and the optimal scenario tree [@Pflug2009]. Process distance extends and generalizes the Wasserstein distance to stochastic processes. It was analyzed in @PflugPichler2011 and they explained that it is suitable to measure the distance between stochastic processes because it takes notice of non-anticipativity related to stochastic processes. @KovacevicPichler used this method directly to generate scenario trees.

Generally, we consider a stochastic process $X$ over a discrete time space $T$, i.e., $X = (X_0,X_1,\ldots,X_T)$ where $X_0$ is a deterministic starting value and the rest are random values. A scenario tree is a discrete time and discrete state process approximating the process $X$. We represent a scenario tree by $\tilde{X} = (\tilde{X}_0,\tilde{X}_1,\ldots,\tilde{X}_T)$. At the end of the stochastic approximation process, the scenario tree $\tilde{X}$ optimally represents the process $X$ such that their multistage distance is minimal.

We describe a scenario tree by its name, parents of the nodes, states of the nodes and the probabilties of transition from one node to another in the tree. We characterize a scenario tree by its root, leaves, height and the stages in the tree. The ``root of the tree`` is the first node of the tree. Each node in the tree has a parent except the root node. This gives a predecessor relationship between parents and children nodes in the tree. Given a child node $i$ at stage $t$ and its parent node $j$ at stage $t-1$, a function mapping $i$ to its parent $j$ is given by $$\mathrm{pred}_t (i) = j.$$ This relationship induces a filtration in the tree. This is the main reason why we use the multistage distance instead of the Wasserstein distance as multistage distance takes notice of the effects of evolution of the process in time.

The ``leaves of the tree`` are all those nodes which do not have children. They are the terminal nodes in the tree. The ``height of the tree`` is the longest path from the root to the leaf. Each node in the tree is at a certain stage. These stages starts from $0$ where the root node is and ends at $T$ where the leaves are. Therefore the height of the tree equals the number of stages, i.e., $H = T$.

``ScenTrees.jl`` is a Julia [@julia] library for generating scenario trees and scenario lattices which can be used, for example, for multistage stochastic optimization problems. The theory and design of the ``ScenTrees.jl`` library follows Algorithm 5 in @PflugPichlerDynScenarioGen. The library's design allows us to obtain a fast code with high flexibility and excellent computational efficiency. The design choices were highly motivated by the properties of the Julia [@JULIA2019] language. It starts with a tree which is a qualified quess by the user or an exper opinion (this tree is represented by its name, parents of each node or the children of the parents, states of the nodes and the probabilities of transition) and iterates over the nodes of the tree updating them with scenarios drawn from a user-defined distribution. In this way, the approximating quality of the tree is improved for each sample generated. The iteration stops when the predefined number of scenarios have been performed. We also consider a scenario lattice represented by the name, states of the nodes and the probabilities of transition.

# Main features of the library

The stochastic approximation algorithm that is implemented in ``ScenTrees.jl`` follow the framework presented in @PflugPichlerDynScenarioGen specifically Algorithm 5 in that paper. This framework allows ``ScenTrees.jl`` to be generally applicable to any stochastic process to be approximated. The following are key features that ``ScenTrees.jl`` provides. Implementation details and examples of usage can be found in the software's documentation.^[https://kirui93.github.io/ScenTrees.jl/latest]

  - ``Process function``: This is a user-specified function that generates trajectories of the stochastic process that the user wants to approximate by a scenario tree or a scenario lattice for the case of Markovian processes. This function should return an array in 2 dimension. This function should not take any inputs else the user should consider using a wrapper function and function closures. For example, depending on the number of stages of the tree and the dimension of the states in the tree that the user wants to approximate, say, `nStages = 5 and dimension = 1`, the function should return a `5x1 Array{Float64,2}` array. In our example below, we want to approximate an ARMA model with 5 stages and in 1 dimension, therefore, we create a function `ARMA()` for that purpose. In 5 stages, ``ARMA()`` will generate $1$ trajectory of the process of length $5$ in $1$ dimension. The user of this library will provide this function depending on what she/he wants to approximate via a scenario tree or a scenario lattice. For more explanation on this, have a look on the documentation.

  - ``Tree``: This provides the structure of a scenario tree. It stores all the information of the tree. These information includes the name of the tree, the parents of the nodes in the tree, the states of the nodes in the tree and the probabilities of transition from one node to another in the tree. A tree can be generated by the function `Tree(BranchingStructure, dimension)`. It returns a tree with state values and probabilities. This is the scenario tree that we want to improve using samples from the stochastic process that we want to approximate.
  
  - ``Tree Approximation``: It returns a valuated probability scenario tree that approximates the stochastic process in a best possible way. The function ``TreeApproximation!(Tree(), Function, NoOfIterations, pNorm, rWasserstein)`` takes:
    1. A scenario tree object from the ``Tree()`` function having a certain branching structure, 
    2. A process function that we want to approximate,
    3. The number of iterations, 
    4. Choice of the norm (Example: `max = 0, sum = 1, Euclidean =2 (default)`), and,
    5. Wasserstein parameter (`rWasserstein = 2 (default)`)
    
    The number of iterations is the number of trajectories that we are going to generate to improve the tree. For each iteration, we generate one trajectory with its length equal to the number of stages in the tree. We then find a sequence of nodes in the tree where the Euclidean distance between the states in the nodes and the trajectory is minimal and then improve these nodes with the values in the trajectory. Each iteration modifies one path in the tree towards the values in the new trajectory and hence the approximating quality of the tree is improved.
  
  - ``Lattice Approximation``: It is used to approximate Markovian processes. The function ``LatticeApproximation(BranchingStructure, Function, NoOfIterations)`` takes:
    1. The branching structure of the lattice, 
    2. The process function that we want to approximate, and 
    3. The number of iterations. 
    
    This approximation follows the same procedure as in the scenario tree approximation. For each stage, we find the closest lattice entry and use the samples generated to improve the found closest entry. The output of this approximation is a valuated lattice characterized by its name, states of the nodes in the lattice and the probabilities of transition of nodes in the lattice.

  - ``Stochastic approximation``: Generally, we use stochastic approximation to improve the actual starting tree given a sample from the stochastic process that user wants to approximate. This step requires that we sample an independent, identically distributed (i.i.d.) sequence, say $\xi(0),\xi(1),\xi(2),\ldots,\xi(T)$ of vectors of length $T$. The length $T$ of these vectors is equal to the number of stages in the tree. We then find a sequence of nodes in the tree where the Euclidean distance between the tree and samples from the stochastic process is minimal. Each state of these nodes is updated with the corresponding value in the sequence. The states in the other nodes remain unchanged. This process goes for a prefixed number of iterations. Every path has a new additional information which improves the approximating quality of the tree. Each stochastic approximation step modifies one path within the tree towards the new sample from the stochastic process. In this way the approximating quality of the tree is improved each time a new sample is observed. The tree is not stable at the beginning but with more and more samples, the scenario tree converges in probability. The resulting scenario tree can then be used for decision making under uncertainty. 
  
  - `Conditional density estimation`: This is a non-parametric techinique for generating samples from a given data. Here we have data from some observed trajectories of a scenario process with an unknown distribution and we want to use the conditional density estimation to generate new but different samples based on the above trajectories. The new samples can then be used to generate a scenario lattice as the samples generated are Markovian. 

# Example 1: Approximating time series

We present the following example to illustrate the use of ``ScenTrees.jl`` to generate scenario tree from a know process. Other examples as well as the detailed user guide can be found in the library's documentation.

## ARMA process

In this example, we want to use the stochastic approximation process to approximate the ARMA series model. Consider the ARMA process with $p=2$ and $q=3$. The process $X_t$ is an ARMA process if the recursion $$X_t = \phi_1 X_{t-1} + \ldots + \phi_p X_{t-p} + Z_t + \theta_1 Z_{t-1} + \ldots + \theta_q Z_{t-q}$$ is valid for $Z_t \sim N(0,\sigma^2)$ which is a white noise process. This process is a non-Markovian process and so we approximate it with a scenario tree.

### Writing the process function

The first important step is to write the process function according to the requirements of the package. That is, write this function such that it takes no inputs as arguments shown below:

```julia
# `ARMA` series in 5 stages and 1 dimension
function ARMA()
  ARphi=[0.89,0.9]; MAtheta=[1.0,2.7,3.9]
  p = length(ARphi); q = length(MAtheta)
  MAtheta = vcat(1,MAtheta)                 # fix the values of q to start at 1
  X = zeros(5,1)                            # initialize a `X` vector to hold the results
  Xp = randn(1,p+1) ; Zq = randn(1,q+1)     # `Xp` and `Zq` starting random values 
  for t in range(1,stop = 5)                # loop to compute Xt
    Zq = circshift(Zq, [0,1])               # roll the values along the columns
    Zq[:,1] = randn(1)                      # `Zq` first random value
    Xp = circshift(Xp, [0,1])
    Xp[:,1] = Xp[:,2:end] * ARphi + Zq * MAtheta
    X[t,:] = Xp[:,1]                       # left shift
  end
  if X[1] > -1 && X[1] < 1                 # filter the resulting trajectories
    return X                          
  else
    ARMA()
  end
end
```
This is the function that generates samples that will improve our scenario tree for every iteration. To approximate the above process with a scenario tree, then we fix the branching structure of the tree. For example, let's take a scenario tree with branching structure `1x3x3x3x3` in `5` stages and one dimension and `1,000,000` number of iterations. The plot in Figure 1 shows 50 realizations of this process:

![50 realizations of ARMA process](images/arma5.pdf){height=250px}

### Approximation of the above process

We want to approximate the above process with a scenario tree using the following procedure. We will also have a look at the different characteristics of a scenario tree using this example:

```julia
julia> using Pkg
julia> Pkg.add("https://github.com/kirui93/ScenTrees.jl.git")
julia> using ScenTrees                    # Load the library
julia> ArmaApprx = TreeApproximation!(Tree([1,3,3,3,3],1), ARMA,1000000,2,2);
```
What is returned is a scenario tree that approximates the process ``ARMA`` in a best possible way. The multistage distance between this scenario tree and the ARMA process is `0.5412`. This shows that the scenario tree better approximates the ARMA process. 

We describe the above scenario tree by ``nodes, height, leaves, stages of nodes and the root`` etc. To have more description of these features, have a look on the package's documentation.^[https://kirui93.github.io/ScenTrees.jl/latest/tutorial/tutorial2/]

```julia
julia> nodes(ArmaApprx)              # nodes in the scenario tree
1:121
julia> height(ArmaApprx)             # height of the scenario tree
4
julia> root(ArmaApprox)              # root of the scenario tree
1-element Array{Int64,1}
1
julia> root(ArmaApprox, 120)         # sequence of nodes to reach node `120`
5-element Array{Int64,1}
1
4
13
40
120
julia> leaves(ArmaApprx)            # leaves, indexes and unconditional probabilities
([41,42,43,44,45,46,47,48,49,50,...,112,113,114,115,116,117,118,119,120,121],
1:81, [0.0119,0.00822,0.01712,0.0084,....,0.00555,0.0646,0.00224,0.0129,0.00634,0.00894])
julia> stage(ArmaApprx)             # stage of each node in the scenario tree
31-element Array{Int64,1}
[0,1,1,1,2,2,2,...,4,4,4,4,4]
julia> treeplot(ArmaApprx)          # Plotting the scenario tree
```
The plot in Figure 2 shows a valuated probability scenario tree that represents the ARMA process:

![Scenario tree (1x3x3x3x3)](images/approx.pdf){height=250px}

# Example 2: Scenario generation from observed trajectories

This is a non-parametric technique for generating trajectories used to generate and improve scenario trees and scenario lattices in the stochastic approximation algorithm. It involves two steps:

    1. Density estimation and,
    2. Stochastic approximation process.

The stochastic approximation process has already been described above so we will concentrate on the density estimation step. The density estimation step involves two steps:

    (a) Estimation of the distribution of conditional densities and,
    (b) Composition method

We estimate the distribution of transition densities given the history of the process. This distribution is estimated by the non-parametric kernel density estimation. The density at stage $t+1$ conditional on the history $\mathbf{x_{t}} = (x_0,x_{i_{1}},x_{i_{2}},\ldots,x_{i_{t}})$ is estimated by 
\begin{equation}\label{eqdens}
\hat{f}_{t+1}(x_{t+1}|\mathbf{x_{t}}) = \sum_{j=1}^{N} \omega_j(\mathbf{x_{t}}) \cdot k_{h_N}(x_{t+1} - \xi_{j,t+1})
\end{equation}
where $k(.)$ is a kernel function, $h_N$ is the bandwidth and $k_{h_N}$ is the weighted kernel function.

The weights are given by
\begin{equation}
\omega_j(\mathbf{x_{t}}) = \frac{k\big(\frac{x_{i_1} - \xi_{j,1}}{h_N}\big)\cdot \ldots \cdot k\big(\frac{x_{i_t} - \xi_{j,t}}{h_N}\big)}{\sum_{\ell=1}^{N}k\big(\frac{x_{i_1} - \xi_{l,1}}{h_N}\big)\cdot \ldots \cdot k\big(\frac{x_{i_t} - \xi_{l,t}}{h_N}\big)}.
\end{equation}
Notice from above that the weights depend on the history $\mathbf{x_{t}}$ upto stage $t$ only. Also, the weights sum up to 1 for every $\mathbf{x_{t}}$, i.e., $\sum_{j=1}^{N} \omega_j(\mathbf{x_{t}}) = 1$.

We use the composition method to find the samples from the conditional distribution $\hat{f}_{t+1}(.|\mathbf{x_{t}})$ as follows. Pick a random number $U \in (0,1)$ where $U$ is uniformly distributed then find a summation index $j^{\star} \in {1,2,\ldots,N}$ such that 
\begin{equation}
\sum_{j=1}^{j^{\star}-1} \omega_j(\mathbf{x_{t}}) < U \leq \sum_{j=1}^{j^{\star}} \omega_j(\mathbf{x_{t}}).
\end{equation}
The cumulative sum of weights leads to a high probability of picking a data path near the observation [@Seguin2015].

The value of the data $\xi_t$ is obtained by setting the value at stage $t$ to $$\xi_t = X_{j^{\star,t}} + \text{rand}_{k_{h_N}}$$ where $\text{rand}_{k_{h_N}}$ is a random value sampled from the kernel estimator using the composition method (@PflugPichlerDynScenarioGen, @PflugPichler2016 and @Seguin2015).

The generated data point is according to the distribution of the density at the current stage and dependent on the history of all the data points. It has been shown that the choice of the kernel does not have an important effect on density estimation [@Jones1990]. Hence, we employ the following logistic kernel in this paper $$k(x) = \frac{1}{(e^x + e^{-x})^2}.$$

One of the most important factor to consider in density estimation is the bandwidth. We use the Silverman's rule of thumb to obtain the bandwidths for each of the data columns as follows 
\begin{equation}
h_N = \sigma(X_t)\cdot N^{\frac{-1}{N+4}}
\end{equation}
where $N$ is the number of available trajectories and $\sigma(X_t)$ is the standard deviation of data in stage $t$.

Using the above procedure, every new sample path starts with $\mathbf{\tilde{\xi_1}} := (x_1)$. Using Equation \ref{eqdens} and the composition method, we find a new sample $\tilde{\xi_2}$ from $\hat{f}_1(.|\mathbf{\tilde{\xi_1}})$ at the first stage. Next, we set $\mathbf{\tilde{\xi_2}} = (\tilde{\xi_1},\tilde{\xi_2})$ and generate a new data point $\tilde{\xi_2}$ from $\hat{f}_2(.|\mathbf{\tilde{\xi_1}})$  at the second stage. The process continues in that manner until the final stage $T$ where we get the final new sample path $\mathbf{\tilde{\xi_T}} = (\tilde{\xi_0},\tilde{\xi_1},\ldots,\tilde{\xi_T})$ which is generated form the initial data $\xi = (\xi_1,\xi_2,\ldots,\xi_T)$. 

Notice that the new sample $\mathbf{\tilde{\xi_T}}$ is Markovian and thus we can approximate the process using a scenario lattice. The new sample path $\mathbf{\tilde{\xi_T}}$ is what we will feed in the stochastic approximation algorithm to generate a scenario lattice.

## Approximating with a scenario lattice

The above process is implemented in our library in `KernelDensityEstimation.jl`. The input of the function is a data in two dimension, in other words, the function takes a matrix of `Float64` or a matrix of `Int64`. We hope that the reader is well aware of the function closures because we use a closure in this script to implement the above procedure. 

The function `KernelScenarios(data::Union{Array{Int64,2},Array{Float64,2}})` takes a $(N \times T)$ dimensional data. The $N$ rows of the data are the number of trajectories in the initial data and the $T$ columns is the number of stages in in each trajectory of the data. What this function returns is a function closure of the data given. To get a sample from this function, we use the normal way of calling function closures. The new sample according to the distribution of the density at the current stage and dependent on the history of all the data points as we shall see in the example below.


### Example

Consider the following data in CSV format. The data has `1000` trajectories in `5` stages (i.e., it is a $(1000\times 5)$ domensional data). As shown below, we use the package `CSV.jl`^[https://github.com/JuliaData/CSV.jl] to read the data into julia and since we need the data in matrix form, we use the function `Matrix` from the package `DataFrames.jl`^[https://github.com/JuliaData/DataFrames.jl] to convert the dataframe into an array in two dimension which is then fed into our function.

```julia
julia> using ScenTrees                           # Load the package
julia> data = CSV.read(".../RandomDataWalk.csv") # Load the csv data from a directory
julia> df = Matrix(data)                         # *Convert the DataFrame into a Matrix
julia> OneSample = KernelScenarios(df)() # The second brackets is for the function closure inside...
                                         # ...the KernelScenarios() function.
5-element Array{Float64,1}:
  2.93133
 -2.09636 
  3.76712 
  2.14765 
  0.94241
```

We can therefore use the above function to generate a scenario lattice as follows. Consider a scenario lattice with a branching structure of $(1\times3\times4\times5\times6)$. Clearly, the lattice we are considering is in 5 stages which conforms to the sample generated by our function above. We take $100,000$ number of iterations for the stochastic approximation algorithm.

```julia
julia> ExampleLattice = LatticeApproximation([1,3,4,5,6],KernelScenarios(df),100000);
julia> PlotLattice(ExampleLattice)
julia> savefig("KernLattice.png")
julia> savefig("KernLattice.pdf")
```

![Lattice Approximation from Kernel Density Samples](images/KernLattice.pdf){height=250px}


# Acknowledgements

This work was supported by the German Academic Exchange Service (DAAD). 

# References
