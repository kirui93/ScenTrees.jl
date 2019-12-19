
using LinearAlgebra: norm, transpose

"""
	TreeApproximation!(newtree::Tree,genPath::Function,nIterations::Int64,p::Int64=2,r::Int64=2)

Returns a valuated probability scenario tree approximating the input stochastic process.

Args:
newtree - Tree with a certain branching structure,
genPath - function generating samples from the stochastic process to be approximated,
nIterations - number of iterations for stochastic approximation procedure,
p - choice of norm (default p = 2 (Euclidean distance)), and,
r - transportation distance parameter
"""
function TreeApproximation!(newtree::Tree,genPath::Function,nIterations::Int64,p::Int64=2,r::Int64=2)
    leaf,omegas,probaLeaf = leaves(newtree)                               #leaves,omegas and probabilities of the leaves of the tree
    dm = size(newtree.state,2)                                            #We get the dim from the dimsention of the states we are working on.
    T = height(newtree)                                                   #height of the tree
    n = length(leaf)                                                      #number of leaves = no of omegas
    d = zeros(Float64,dm,length(leaf))
    samplepath = zeros(Float64,T+1,dm)
    probaLeaf = zero(probaLeaf)
    probaNode = nodes(newtree)                                             #all nodes of the tree
    path_to_leaves = [root(newtree,i) for i in leaf]                       # all the paths from root to the leaves
    path_to_all_nodes = [root(newtree,j) for j in probaNode]               # all paths to other nodes
    @inbounds for k = 1:nIterations
        critical = max(0.0,0.2*sqrt(k) - 0.1* n)
        #tmp = findall(xi -> xi <= critical, probaLeaf)
        tmp = Int64[inx for (inx,ppf) in enumerate(probaLeaf) if ppf <= critical]
        copyto!(samplepath,genPath())                                           #sample path (nStages,nPaths) i.e a new scenario path
        #The following part addresses the critical probabilities of the tree so that we don't loose the branches
        if !isempty(tmp) && !iszero(tmp)
            probaNode = zero(probaNode)
            probaNode[leaf] = probaLeaf
            @inbounds for i = leaf
                while newtree.parent[i] > 0
                    probaNode[newtree.parent[i]] = probaNode[newtree.parent[i]] + probaNode[i]
                    i = newtree.parent[i]
                end
            end
            @inbounds for tmpi = tmp
                rt = path_to_leaves[tmpi]
                #tmpi = findall(pnt -> pnt <= critical, probaNode[rt])
                tmpi = Int64[ind for (ind,pnt) in enumerate(probaNode[rt]) if pnt <= critical]
                newtree.state[rt[tmpi],:] .= samplepath[tmpi,:]
            end
        end
        #To the step  of STOCHASTIC COMPUTATIONS
        EndLeaf = 0 #start from the root
        for t = 1:T+1
            tmpleaves = newtree.children[EndLeaf+1]
            disttemp = Inf #or fill(Inf,dm)
            for i = tmpleaves
                dist = norm(view(samplepath, 1:t) - view(newtree.state, path_to_all_nodes[i]), p)
                if dist < disttemp
                    disttemp = dist
                    EndLeaf = i
                end
            end
        end
        #istar = findall(lf -> lf == EndLeaf, leaf)
        istar = Int64[idx for (idx,lf) in enumerate(leaf) if lf == EndLeaf]
        probaLeaf[istar] = probaLeaf[istar] .+ 1.0                                                            #counter  of probabilities
        StPath = path_to_leaves[EndLeaf-(leaf[1]-1)]
        delta = newtree.state[StPath,:] - samplepath
        d[:,istar] = d[:,istar] .+ norm(delta, p).^(r)
        delta .=  r .* norm(delta, p).^(r - p) .* abs.(delta)^(p - 1) .* sign.(delta)
        ak = 1.0 ./ (30.0 .+ probaLeaf[istar]) #.^ 0.75        # sequence for convergence
        newtree.state[StPath,:] -= delta .* ak
    end
    probabilities  = map(plf -> plf/sum(probaLeaf), probaLeaf) #divide every element by the sum of all elements
    t_dist = (d * hcat(probabilities) / nIterations) .^ (1/r)
    newtree.name = "Stochastic Approximation with d=$(round.(t_dist,digits=5)) at $(nIterations) iterations"
    newtree.probability .= buildProb!(newtree,hcat(probabilities)) #build the probabilities of this tree
    return newtree
end
