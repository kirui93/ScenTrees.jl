"""
We start with a predefined tree. We already known the bushiness of the treee, number of stages in the tree, height of the tree,
leaves in the tree, nodes of the tree e.t.c. The tree we start with is just random and is not good for stochastic approximation.
Therefore, we take a path, either GaussianSamplePath or RunningMaximum and a number of scenarios and then try to improve this tree using the simulated path.
The function Stochastic approximation tree takes a path, newtree, samplesize, pNorm and rwassertein.
"""

using LinearAlgebra: norm, transpose

"""
	TreeApproximation!(newtree::Tree,genPath::Function,samplesize::Int64,pNorm::Int64=2,rwasserstein::Int64=2)

Returns a valuated probability scenario tree. Note that the inputs are in the following order: Tree(), path, sample size, 2,2.
The function `Tree()` takes the branching structure and the dimension of the tree.
"""

function TreeApproximation!(newtree::Tree,genPath::Function,samplesize::Int64,pNorm::Int64=2,rwasserstein::Int64=2)
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

    @inbounds for k = 1: samplesize
        critical = max(0.0,0.2*sqrt(k) - 0.1* n)
        #tmp = findall(xi -> xi <= critical, probaLeaf)
        tmp = Int64[inx for (inx,ppf) in enumerate(probaLeaf) if ppf <= critical]
        samplepath .= map(genPath,T+1,dm)                                   #sample path (nStages,nPaths) i.e a new scenario path

        """
          This part addresses the critical probabilities of the tree so that we don't loose the branches
        """

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
                dist = norm(view(samplepath, 1:t) - view(newtree.state, path_to_all_nodes[i]), pNorm)
                if dist < disttemp
                    disttemp = dist
                    EndLeaf = i
                end
            end
        end
        #istar = findall(lf -> lf == EndLeaf, leaf)
        istar = Int64[idx for (idx,lf) in enumerate(leaf) if lf == EndLeaf]
        probaLeaf[istar] .= probaLeaf[istar] .+ 1.0                                                            #counter  of probabilities
        StPath = path_to_leaves[EndLeaf-(leaf[1]-1)]          
        delta = newtree.state[StPath,:] - samplepath
        d[:,istar] .= d[:,istar] .+ norm(delta, pNorm).^(rwasserstein)
        delta .=  rwasserstein .* norm(delta, pNorm).^(rwasserstein - pNorm) .* abs.(delta)^(pNorm - 1) .* sign.(delta)
        ak = 1.0 ./ (30.0 .+ probaLeaf[istar]) .^ 0.75
        newtree.state[StPath,:] = newtree.state[StPath,:] - delta .* ak
    end
    probabilities  = map(plf -> plf/sum(probaLeaf), probaLeaf) #divide every element by the sum of all elements
    transportationDistance = (d * hcat(probabilities) / samplesize) .^ (1/rwasserstein)
    newtree.name = "Stochastic Approximation ,d=$(round.(transportationDistance,digits=5)),$(samplesize) scenarios"
    newtree.probability .= buildProb!(newtree,hcat(probabilities)) #build the probabilities of this tree
    return newtree
end
