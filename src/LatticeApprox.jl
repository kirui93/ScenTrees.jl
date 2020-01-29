
using Statistics, LinearAlgebra, PyPlot

mutable struct Lattice
    name::String
    state::Array{Array{Float64,2},1}
    probability::Array{Array{Float64,2},1}
    Lattice(name::String, state::Array{Array{Float64,2},1}, probability::Array{Array{Float64,2},1}) = new(name, state, probability)
end

"""
	lattice_approximation(bstructure::Array{Int64,1}, path::Function, nIterations::Int64, r::Int64 = 2)

Returns an approximated lattice approximating the stochastic process provided.

Args:
bstructure - branching structure of the scenario lattice e.g., bstructure = [1,2,3,4,5] represents a 5-staged lattice
path - function generating samples from known distribution with length equal to the length of bstructure of the lattice.
nIterations - number of iterations for stochastic approximation algorithm.
r - parameter for the transportation distance.
"""
function lattice_approximation(bstructure::Array{Int64,1}, path::Function, nIterations::Int64, r::Int64 = 2)
    t_dist = 0.0                               # multistage distance
    T = length(bstructure)     # number of stages in the scenario lattice
    states = [zeros(bstructure[j], 1) for j = 1 : T]   # States of the lattice at each time t
    init_lat = path()         # initialize the states of the nodes of the lattice
    for t = 1:T
        states[t] .= init_lat[t]
    end
    probabilities = vcat([zeros(bstructure[1], 1)], [zeros(bstructure[j-1], bstructure[j]) for j = 2 : T]) # Probabilities of the lattice at each time t
    Z = Array{Float64}(undef,T,1)  # initialize a 1D vector to hold the state values
    #Stochastic approximation procedure to update the values on the nodes of the scenario lattice.
    for n = 1:nIterations
        Z .= path(); last_index = 1; dist = 0.0
        for t = 1 : T #walk along the gradient
            # corrective action to include lost nodes
            states[t][findall(sum(probabilities[t], dims = 2) .< 1.3 * sqrt(n) / bstructure[t])] .= Z[t]
            min_dist, new_index = findmin(abs.(vec(states[t] .- Z[t])))  # find the closest lattice entry
            dist += min_dist^2                             # Euclidean distance for the paths
            probabilities[t][last_index,new_index] += 1.0        # increase the probability
            last_index = new_index
            states[t][new_index] = states[t][new_index] - (r * min_dist^(r-1) * (states[t][new_index] - Z[t]) / (3000 + n)^0.75)
        end
        dist = dist^(1/2)
        t_dist = (t_dist*(n-1) + dist^r)/n
    end
    probabilities = probabilities / nIterations						                # scale the probabilities to 1.0
    return Lattice("Lattice $bstructure with distance=$(t_dist^(1/r)) after $(nIterations) iterations ", states, probabilities)
end

"""
	PlotLattice(lt::Lattice,fig=1)

Returns a plot of a lattice.
"""
function plot_lattice(lt::Lattice,fig = 1)
    if !isempty(fig)
        figure(figsize=(6,4))
    end
    lts = subplot2grid((1,4),(0,0),colspan = 3)
    title("states")
    xlabel("stage,time",fontsize=11)
    #ylabel("states")
    xticks(1:length(lt.state))
    lts.spines["top"].set_visible(false)                                                         # remove the box at the top
    lts.spines["right"].set_visible(false)                                                       # remove the box at the right
    for t = 2:length(lt.state)
        for i=1:length(lt.state[t-1])
            for j=1:length(lt.state[t])
                lts.plot([t-1,t],[lt.state[t-1][i],lt.state[t][j]])
            end
        end
    end

    prs = subplot2grid((1,4), (0,3))
    title("probabilities")
    prs.spines["top"].set_visible(false)
    prs.spines["left"].set_visible(false)
    prs.spines["right"].set_visible(false)
# Use the states and probabilites at the last stage to plot the marginal distribution
    stts = lt.state[end]
    n = length(stts)                                    # length of terminal nodes of the lattice.
    h = 1.05 * std(stts) / (n^0.2) + eps()                  #Silverman rule of thumb
    #lts.set_ylim(minimum(stts)-1.5*h, maximum(stts)+1.5*h)
    #prs.set_ylim(minimum(stts)-3.0*h, maximum(stts)+3.0*h)
    proba = sum(lt.probability[end], dims=1)
    yticks(())                                          #remove the ticks on probability plot
    t = LinRange(minimum(stts) - h, maximum(stts) + h, 100) #100 points on probability plot
    density = zero(t)
    for (i, ti) in enumerate(t)
        for (j, xj) in enumerate(stts)
            tmp = (xj - ti) / h
            density[i] += proba[j]* 35/32 * max(1.0 -tmp^2, 0.0)^3 / h #triweight kernel
        end
    end
    plot(density, t)
    prs.fill_betweenx(t, 0 , density)
end
