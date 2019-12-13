
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
    # We use the function closure here because we want to use this function in the stochastic approximation process.
    # That is, we wwant to follow the specifications of the TreeApproximation and Latticeapproximation inputs.
    # The way we have created the stochastic approximation functions is that it takes a function which does not take any inputs.
    # And so the outer function takes the data and the distribution of the kernel while the inner function takes no inputs.
    # To obtain the result then, call "KernelScenarios(data,Logistic)()".
    # Notice we have an input of whether you are creating Markovian trajectories or not.
    # This is important for generating either scenario trees or scenario lattices.
    # The default for Markovian is true hence the trajectory created is Markovian which is used for scenario lattices.
    function closure()
        N,T = size(data)                                                  # Dimensions of the data
        d = 1
        w = fill(1.0,N)                                                     # initialize the weights
        x = Array{Float64,1}(undef,T)                                     # trajectory to be created
        for t = 1:T
            w = w / sum(w)                                                # normalized weights
            Nt = sum(w)^2 / sum(w.^2)                                     # effective sample size
            σt = sqrt(sum(w .* ((data[:,t] .- sum(w .* data[:,t])).^2)))  # effective standard devistion
            ht = σt * Nt^(-1/(d + 4)) + eps()
            # Composition method comes in here
            u = rand(rng,Uniform(0,1))
            _,jstar = findmin(cumsum(w) .< u * sum(w))
            # The cumulative sum of weights leads to a high probability of picking a data path near an observation (Sequin && Pichler 2017)
            x[t] = rand(rng,kernelDistribution(data[jstar,t],ht))
            # The new generated value is according to the distribution of density of the current stage and dependent on the history of all the data paths.
            # All the rows in the column are associated with a certain weight as follows:
            # Each weight is a product of the kernels of the data at that point.
            if t<T
                # The choice of the kernel does not have any important effect on density estimation (Jones (1990)).
                if Markovian
                    for j = 1:N
                        # Markovian is used for scenario lattices
                        w[j] = pdf(kernelDistribution(data[j,t],ht),x[t])
                    end
                else
                    for j = 1:N
                        # Non-Markovian is used for scenario trees
                        w[j] *= pdf(kernelDistribution(data[j,t],ht),x[t])
                    end
                end
            end
        end
        return x        # The length of x is equal to the number stages = T
    end
end
