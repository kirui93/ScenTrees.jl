
using Distributions, Statistics

"""
    KernelScenarios(data::Union{Array{Int64,2},Array{Float64,2}},kernelDistribution = Logistic)
    
    This function takes a matrix of data in 2 dimension (NxT) where N is the number of trajectories and T is the number of stages.
    It uses function closures and above is a function.
    To get results a trajectory from above, `KernelScenarios(data,kernelDistribution)()` gives the result.
    User specifies both data and the distribution of the kernel he/she wants to use. The default kernel is the Logistic kernel.
"""

function KernelScenarios(data::Union{Array{Int64,2},Array{Float64,2}},kernelDistribution = Logistic)
    # We use the function closure here because we want to use this function in the stochastic approximation process.
    # That is, we wwant to follow the specifications of the TreeApproximation and Latticeapproximation inputs.
    # The way we have created the stochastic approximation functions is that it takes a function which does not take any inputs.
    # And so the outer function takes the data and the distribution of the kernel while the inner function takes no inputs.
    # To obtain the result then, call "KernelScenarios(data,Logistic)()".
    function closure()
        N,T = size(data)                                                  # Dimensions of the data
        d = 1
        w = fill(1.0,N)                                                     # initialize the weights
        ξ = Array{Float64,1}(undef,T)                                     # trajectory to be created
        for t = 1:T
            w = w / sum(w)                                                # normalized weights
            Nt = sum(w)^2 / sum(w.^2)                                     # effective sample size
            σt = sqrt(sum(w .* ((data[:,t] .- sum(w .* data[:,t])).^2)))  # effective standard devistion
            ht = σt * Nt^(-1/(d + 4)) + eps()
            # Composition method comes in here
            u = rand(Uniform(0,1))
            _,jstar = findmin(cumsum(w) .< u * sum(w))
            # The cumulative sum of weights leads to a high probability of picking a data path near an observation (Sequin && Pichler 2017)
            ξ[t] = rand(kernelDistribution(data[jstar,t],ht))
            # The new generated value is according to the distribution of density of the current stage and dependent on the history of all the data paths.
            # All the rows in the column are associated with a certain weight as follows:
            # Each weight is a product of the kernels of the data at that point.
            if t<T
                for j = 1:N
                    # The choice of the kernel does not have any important effect on density estimation (Jones (1990)).
                    w[j] *= pdf(kernelDistribution(data[j,t],ht),ξ[t]) 
                end
            end
        end
        return ξ                         # The length of ξ is equal to the number stages = T
    end
end
