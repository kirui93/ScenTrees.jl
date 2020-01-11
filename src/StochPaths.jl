#All these examples of path are in 4 stages

using Distributions, Random
rng = MersenneTwister(01012019);

"""
	GaussianSamplePath1D()

Returns a '4x1' dimensional array of Gaussian random walk
"""
function GaussianSamplePath1D()
    return vcat(0.0, cumsum(randn(rng, 3, 1), dims = 1)) #4 stages
end

"""
	GaussianSamplePath2D()

Returns a '4x2' dimensional array of Gaussian random walk
"""
function GaussianSamplePath2D()
    gsmatrix = randn(rng, 4, 2) * [1.0 0.0 ; 0.9 0.3] #will create an (dimension x nstages) matrix
    gsmatrix[1,:] .= 0.0
    return cumsum(gsmatrix .+ [1.0 0.0], dims = 1)
end

"""
	RunningMaximum1D()

Returns a '4x1' dimensional array of Running Maximum process.
"""
function RunningMaximum1D()
    rmatrix = vcat(0.0, cumsum(randn(rng, 3, 1), dims = 1))
    for i = 2 : 4
        rmatrix[i] = max.(rmatrix[i-1], rmatrix[i])
    end
    return rmatrix
end

"""
	RunningMaximum1D()

Returns a '4x2' dimensional array of Running Maximum process.
"""
function RunningMaximum2D()
    rmatrix = vcat(0.0, cumsum(randn(rng, 3, 1), dims = 1))
    rmatrix2D = zeros(4, 2)
    rmatrix2D[:,1] .= vec(rmatrix)
    for j = 2 : 2
        for i = 2 : 4
            rmatrix2D[i,j] = max.(rmatrix[i-1], rmatrix[i])
        end
    end
    return rmatrix2D * [1.0 0.0; 0.9 0.3]
end

"""
	path()

Returns a sample of stock prices following the a simple random random process.
"""
function path()
    return  100 .+ 50 * vcat(0.0, cumsum(randn(rng, 3, 1), dims = 1))
end
