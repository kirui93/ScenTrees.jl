
using Distributions, Statistics
using Random
rng = MersenneTwister(01012019);

"""
    KernelScenarios(data::Union{Array{Int64,2},Array{Float64,2}},kernelDistribution = Logistic;Markovian::Bool = true)

Returns an instance of a closure of the conditional density estimation method.

Args:
data - a matrix of data in 2 dimension (NxT) where N is the number of trajectories and T is the number of stages.
kernelDistribution - the distribution of the kernel functions. Default is Logistic distribution.

An optional keyword `Markovian` is passed to handle weights
for Markovian trajectories or non-Markovian ones.

To get a Markov trajectory from above,
`KernelScenarios(data,kernelDistribution;Markovian=true)()` gives the result for
Markovian samples, which is used to generate a scenario lattice.
"""
function KernelScenarios(data::Union{Array{Int64,2},Array{Float64,2}},kernelDistribution = Logistic; Markovian::Bool = true)
    function closure()
        N,T = size(data)                                                  # Dimensions of the data
        d = 1
        w = fill(1.0,N)                                                   # initialize the weights
        x = Array{Float64,1}(undef,T)                                     # trajectory to be created
        for t = 1:T
            w = w / sum(w)                                                # normalized weights
            Nt = sum(w)^2 / sum(w.^2)                                     # effective sample size
            σt = sqrt(sum(w .* ((data[:,t] .- sum(w .* data[:,t])).^2)))  # effective standard devistion
            ht = σt * Nt^(-1/(d + 4)) + eps()
            # Composition method comes in here
            u = rand(rng,Uniform(0,1))
            _,jstar = findmin(cumsum(w) .< u * sum(w))
            x[t] = rand(rng,kernelDistribution(data[jstar,t],ht))
            if t<T
                if Markovian      # Markovian is used for scenario lattices
                    for j = 1:N
                        w[j] = pdf(kernelDistribution(data[j,t],ht),x[t])
                    end
                else             # Non-Markovian is used for scenario trees
                    for j = 1:N
                        w[j] *= pdf(kernelDistribution(data[j,t],ht),x[t])
                    end
                end
            end
        end
        return x        # The length of x is equal to the number stages = T
    end
end
