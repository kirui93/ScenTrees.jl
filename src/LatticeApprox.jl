
using Statistics
using LinearAlgebra
using PyPlot

mutable struct Lattice
    name::String
    state::Array{Array{Float64,2},1}
    probability::Array{Array{Float64,2},1}
    Lattice(name::String,state::Array{Array{Float64,2},1},probability::Array{Array{Float64,2},1}) = new(name,state,probability)
end

"""
	LatticeApproximation(states::Array{Int64,1},path::Function,nIterations::Int64)

Returns an approximated lattice approximating the stochastic process provided.

Args:
states - branching structure of the scenario lattice e.g., states = [1,2,3,4,5] represents a 5-staged lattice
path - function generating samples from known distribution with length equal to the length of states of the lattice.
nIterations - number of iterations for stochastic approximation algorithm.
"""
function LatticeApproximation(states::Array{Int64,1},path::Function,nIterations::Int64)
    t_dist = 0.0                               # multistage distance
    r = 2                                      # parameter = r for transportation map
    lns = length(states)
    LatState = [zeros(states[j],1) for j = 1:lns]   # States of the lattice at each time t
    BegPath = path()
    for t = 1:lns                                #initialize the states of the nodes of the lattice
        copyto!(LatState[t],BegPath[t])
    end
    LatProb = vcat([zeros(states[1],1)],[zeros(states[j-1],states[j]) for j = 2:lns]) # Probabilities of the lattice at each time t
    Z = Array{Float64}(undef,lns,1)                   # initialize a 1D vector to hold the state values
    #Stochastic approximation procedure to update the values on the nodes of the scenario lattice.
    for n = 1:nIterations
        copyto!(Z,path());last_index = 1;dist = 0.0
        for t = 1:length(states) #walk along the gradient
            LatState[t][findall(sum(LatProb[t],dims = 2) .< 1.3 * sqrt(n) / states[t])] .= Z[t]# corrective action to include lost nodes
            min_dist,new_index = findmin(vec(abs.(LatState[t] .- Z[t])))  # find the closest lattice entry
            dist += min_dist^2                             # Euclidean distance for the paths
            LatProb[t][last_index,new_index] += 1.0        # increase the probability
            last_index = new_index
            LatState[t][new_index] -= (2/(3000+n)^0.75)*r*min_dist^(r-1)*(LatState[t][new_index] - Z[t])
        end
        dist = dist^(1/2)
        t_dist = (t_dist*(n-1) + dist^r)/n
    end
    LatProb = LatProb ./ nIterations						                # scale the probabilities to 1.0
    return Lattice("Lattice Approximation of $states,\n distance=$(round(t_dist^(1/r),digits = 8)) at $(nIterations) iterations ", LatState, LatProb)
end

"""
	PlotLattice(lt::Lattice,fig=1)

Returns a plot of a lattice.
"""
function PlotLattice(lt::Lattice,fig = 1)
    if !isempty(fig)
        figure(figsize=(6,4))
    end
    lts = subplot2grid((1,4),(0,0),colspan = 3)
    title("states")
    xlabel("stage,time",fontsize=12)
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
    h = 0.9*std(stts)/ (n^0.2) + eps()                  #Silverman rule of thumb
    #lts.set_ylim(minimum(stts)-1.5*h, maximum(stts)+1.5*h)
    #prs.set_ylim(minimum(stts)-3.0*h, maximum(stts)+3.0*h)
    proba = sum(lt.probability[end],dims=1)
    yticks(())                                          #remove the ticks on probability plot
    t = LinRange(minimum(stts)-h, maximum(stts)+h, 100) #100 points on probability plot
    density = zero(t)
    for (i, ti) in enumerate(t)
        for (j, xj) in enumerate(stts)
            tmp = (xj - ti) / h
            density[i] += proba[j]* 35/32 * max(1.0 -tmp^2, 0.0)^3 /h #triweight kernel
        end
    end
    plot(density, t)
    prs.fill_betweenx(t, 0 , density)
end
