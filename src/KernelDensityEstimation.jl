
using Distributions, Statistics

"""
    KernelScenarios(data::Union{Array{Int64,2},Array{Float64,2}},kernelDistribution = Logistic)
    
    This function takes a matrix of data in 2 dimension (NxT) where N is the number of trajectories and T is the number of stages.
    It uses function closures and above is a function.
    To get results a trajectory from above, `KernelScenarios(data,kernelDistribution)()` gives the result.
    User specifies both data and the distribution of the kernel he/she wants to use. The default kernel is the Logistic kernel.
"""

# We will be suing function closures in this as it allows us to call a function inside a function.
function KernelScenarios(data::Union{Array{Int64,2},Array{Float64,2}},kernelDistribution = Logistic)
    N,T = size(data)                                               # Dimensions of the data
    d = 1
    hN = Array{Float64,1}(undef,T)
    for t=1:T
        hN[t] = std(data[:,t]) / (N^(1/(d +4))) + 1e-5            # hN is the bandwidth of the t column
    end
    w = fill(1/N,N)                                               # initialize the weights
    ξ = Array{Float64,1}(undef,T)                                 # trajectory to be created
    function closure()
        for t = 1:T
            # Composition method comes in here
            u = rand(Uniform(0,1))
            _,jstar = findmin(cumsum(w) .> u * sum(w))
            # The cumulative sum of weights leads to a high probability of picking a data path near an observation (Sequin && Pichler 2017)
            ξ[t] = rand(kernelDistribution(data[jstar,t],hN[t]))
            # The new generated value is according to the distribution of density of the current stage and dependent on the history of all the data paths.
            # All the rows in the column are associated with a certain weight as follows:
            # Each weight is a product of the kernels of the data at that point.
            if t<T
                for j = 1:N
                    # The choice of the kernel does not have any important effect on density estimation (Jones (1990)).
                    w[j] *= pdf(kernelDistribution(data[j,t],hN[t]),ξ[t]) 
                end
                w = w ./ sum(w)
            end
        end
        #ξ[1] = mean(data[:,1])           # Fix a common starting value for each trajectory created. This is the root.
        return ξ                         # The length of ξ is equal to the number stages = T
    end
end
