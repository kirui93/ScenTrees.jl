"""
	GaussianSamplePath(nStages::Int64,d::Int64)

The stochastic approximation process takes a simulated scenario path and updates the tree.
We have two functions, GaussianSamplePath and RunningMaximum which helps us to generate normally distributed random variables.
Each of them can generate random variables upto the d dimension.
nStages - the number of stages in the tree we want to improve.
nPaths - number of paths we want to generate, defaulted to 1.
d - dimension that we are working on; only possible for 1 and 2D, for now.
"""

function GaussianSamplePath(nStages::Int64,d::Int64)
    if d == 1
        return vcat(0.0,cumsum(randn(nStages-1,d),dims = 1))
    else
        gsmatrix = randn(nStages,d) * [1.0 0.0; 0.9 0.3] #will create an (dimension x nstages) matrix
        gsmatrix[1,:] .= 0.0
        return cumsum(gsmatrix .+ [1.0 0.0], dims = 1)
    end
end

function RunningMaximum(nStages::Int64,d::Int64)
    rmatrix = vcat(0.0,cumsum(randn(nStages-1,1),dims = 1))
    if d == 1
        for i = 2:nStages
            rmatrix[i] = max(rmatrix[i-1], rmatrix[i])
        end
        return rmatrix
    else
        rmatrix2D = zeros(nStages,d)
        rmatrix2D[:,1] = rmatrix
        for j=2:d
            for i=2:nStages
                rmatrix2D[i,j] = max(rmatrix[i-1],rmatrix[i])
            end
        end
        return rmatrix2D
    end    
end
