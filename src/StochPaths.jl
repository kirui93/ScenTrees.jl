
"""
	GaussianSamplePath()

The stochastic approximation process takes a simulated scenario path and updates the tree.
We have two functions, GaussianSamplePath and RunningMaximum which helps us to generate normally distributed random variables.
Each of them can generate random variables upto the d dimension.
nStages - the number of stages in the tree we want to improve.
nPaths - number of paths we want to generate, defaulted to 1.
d - dimension that we are working on; only possible for 1 and 2D, for now.
"""

#All these examples of path are in 4 stages

using Distributions

function GaussianSamplePath1D()
    return vcat(0.0,cumsum(randn(3,1),dims = 1)) #4 stages
end

function GaussianSamplePath2D()
    gsmatrix = randn(4,2) * [1.0 0.0; 0.9 0.3] #will create an (dimension x nstages) matrix
    gsmatrix[1,:] .= 0.0
    return cumsum(gsmatrix .+ [1.0 0.0], dims = 1)
end

function RunningMaximum1D()
    rmatrix = vcat(0.0,cumsum(randn(3,1),dims = 1))
    for i = 2:4
        rmatrix[i] = max.(rmatrix[i-1], rmatrix[i])
    end
    return rmatrix
end

function RunningMaximum2D()
    rmatrix = vcat(0.0,cumsum(randn(3,1),dims = 1))
    rmatrix2D = zeros(4,2)
    rmatrix2D[:,1] .= vec(rmatrix)
    for j=2:2
        for i=2:4
            rmatrix2D[i,j] = max.(rmatrix[i-1],rmatrix[i])
        end
    end
    return rmatrix2D * [1.0 0.0; 0.9 0.3]
end

function path()
    return  100 .+ 50 * vcat(0.0,cumsum(randn(3,1),dims = 1))
end

