
using Distributions, Statistics

function LogisticKernel(x::Float64,h::Float64)    # This is the density function of a logistic random variable
    # x - data points
    # h - bandwidth
    return 1/(exp(x/h) +  exp(-x/h)).^2
end
# We will be suing function closures in this as it allows us to call a function inside a function.
function KernelScenarios(data::Union{Array{Int64,2},Array{Float64,2}})
    N,T = size(data)                                               # Dimensions of the data
    hN = Array{Float64,1}(undef,T)
    for t=1:T
        hN[t] = std(data[:,t]) / (N^(1/(N +4))) + 1e-5            # hN is the bandwidth of the t column
    end
    w_j = fill(1/N,N)                                             # initialize the weights
    ξ = Array{Float64,1}(undef,T)                                 # trajectory to be created
    function closure()
        for t = 1:T
            # Composition method comes in here
            u = rand(Uniform(0,1))
            jstar = minimum(findall(cumsum(w_j) .> u * sum(w_j)))
            # The cumulative sum of weights leads to a high probability of picking a data path near an observation.
            # Sequin && Pichler 2017
            ξ[t] = data[jstar,t] + hN[t] * rand(Logistic(0,1))
            # ξ_t = X_istar + hN * log p/(1-p)
            # The new generated value is according to the distribution of density of the current stage and dependent on the history of all the data paths.
            # All the rows in the column are associated with a certain weight as follows:
            # Each weight is a product of the kernels of the data at that point.
            for j = 1:N
                # The choice of the kernel does not have any important effect on density estimation (Jones (1990)).
                w_j[j] = (1/N) * prod(LogisticKernel(ξ[t] - data[j,t],hN[t])) / sum(prod(LogisticKernel(ξ[t] - data[j,t],hN[t])))
            end
        end
        ξ[1] = mean(data[:,1])           # Fix a common starting value for each trajectory created. This is the root.
        return ξ                         # The length of ξ is equal to the number stages = T
    end
end
