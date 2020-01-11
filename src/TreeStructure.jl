
using Distributions, Statistics, PyPlot, Random
rng = MersenneTwister(01012019);

#This defines the tree structure.
mutable struct Tree
    name::String                        # name of the tree
    parent::Vector{Int64}               # parents of nodes in the tree
    children::Vector{Vector{Int64}}     # successor nodes of each parent
    state::Matrix{Float64}              # states of nodes in the tree
    probability::Matrix{Float64}        # probability to go from one node to another

    """
    	Children(parent::Vector{Int64})

    Returns a vector of successors of each of the parent nodes.
    """
    function Children(parent::Vector{Int64})
        allchildren = Vector{Vector{Int64}}([])
        for node in unique(parent)
            push!(allchildren, [i for i = 1 : length(parent) if parent[i] == node])
        end
        return allchildren
    end
    Tree(name::String,parent::Vector{Int64},
    children::Vector{Vector{Int64}},
    state::Matrix{Float64}, probability::Matrix{Float64})=new(name, parent, Children(parent), state, probability)

    """
    	Tree(identifier::Int64)

    Returns some examples of predefined trees.
    These are (0, 302, 303, 304, 305, 306, 307, 402, 404, 405).
    You can call any of the above tree and plot to see the properties of the tree.
    """
    function Tree(identifier::Int64)
        self= new()
        if identifier==0
            self.name = "Empty Tree"
            self.parent = zeros(Int64 , 0)
            self.children = Children(self.parent)
            self.state = zeros(Float64, 0)'
            self.probability = ones(Float64, 0)'
        elseif identifier == 302
            self.name = "Tree 1x2x2"
            self.parent =[0,1,1,2,2,3,3]
            self.children = Children(self.parent)
            self.state = [2.0 2.1 1.9 4.0 1.0 3.0]'
            self.probability = [1.0 0.5 0.5 0.5 0.5 0.5 0.5]'
        elseif identifier == 303
            self.name = "Tree 1x1x4"
            self.parent = [0,1,2,2,2,2]
            self.children = Children(self.parent)
            self.state = [3.0 3.0 6.0 4.0 2.0 0.0]'
            self.probability = [1.0 1.0 0.25 0.25 0.25 0.25]'
        elseif identifier == 304
            self.name = "Tree 1x4x1x1"
            self.parent = [0,1,2,0,4,5,0,7,8,0,10,11]
            self.children = Children(self.parent)
            self.state = [0.1 2.1 3.0 0.1 1.9 1.0 0.0 -2.9 -1.0 -0.1 -3.1 -4.0]'
            self.probability = [0.14 1.0 1.0 0.06 1.0 1.0 0.48 1.0 1.0 0.32 1.0 1.0]'
        elseif identifier == 305
            self.name = "Tree 1x1x4"
            self.parent = [0,1,2,2,2,2]
            self.children = Children(self.parent)
            self.state = [0.0 10.0 28.0 22.0 21.0 20.0]'
            self.probability = [1.0 1.0 0.25 0.25 0.25 0.25]'
        elseif identifier == 306
            self.name = "Tree 1x2x2"
            self.parent = [0,1,1,2,2,3,3]
            self.children = Children(self.parent)
            self.state = [0.0 10.0 10.0 28.0 22.0 21.0 20.0]'
            self.probability = [1.0 0.5 0.5 0.5 0.5 0.5 0.5]'
        elseif identifier == 307
            self.name = "Tree 1x4x1"
            self.parent = [0,1,1,1,1,2,3,4,5]
            self.children = Children(self.parent)
            self.state = [0.0 10.0 10.0 10.0 10.0 28.0 22.0 21.0 20.0]'
            self.probability = [1.0 0.25 0.25 0.25 0.25 1.0 1.0 1.0 1.0]'
        elseif identifier == 401
            self.name = "Tree 1x1x2x2"
            self.parent = [0,1,2,2,3,3,4,4]
            self.children = Children(self.parent)
            self.state = [10.0 10.0 8.0 12.0 9.0 6.0 10.0 13.0]'
            self.probability = [1.0 1.0 0.66 0.34 0.24 0.76 0.46 0.54]'
        elseif identifier == 402
            self.name = "Tree 1x2x2x2"
            self.parent = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
            self.children = Children(self.parent)
            self.state = [10.0 12.0 8.0 15.0 11.0 9.0 5.0 18.0 16.0 13.0 11.0 10.0 7.0 6.0 3.0]'
            self.probability = [1.0 0.8 0.7 0.3 0.2 0.8 0.4 0.6 0.2 0.5 0.5 0.4 0.6 0.7 0.3]'
        elseif identifier == 4022
            self.name = "Tree 1x2x2x2"
            self.parent = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
            self.children = Children(self.parent)
            self.state = [10.0 0.0; 12.0 1.0; 8.0 -1.0; 15.0 2.0; 11.0 1.0; 9.0 -0.5; 5.0 -2.0; 18.0 3.0; 16.0 1.8; 13.0 0.9; 11.0 0.2; 10.0 0.0; 7.0 -1.2; 6.0 -2.0; 3.0 -3.2]
            self.probability = [1.0 0.8 0.7 0.3 0.2 0.8 0.4 0.6 0.2 0.5 0.5 0.4 0.6 0.7 0.3]'
        elseif identifier ==404
            self.name = "Tree 1x2x2x2"
            self.parent = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
            self.children = Children(self.parent)
            self.state = (0.2+0.6744).*[0.0 1.0 -1.0 2.0 0.1 0.0 -2.0 3.0 1.1 0.9 -1.1 1.2 -1.2 -0.8 -3.2]'
            self.probability = [1.0 0.3 0.7 0.2 0.8 0.1 0.9 0.5 0.5 0.6 0.4 0.4 0.6 0.3 0.7]'
        elseif identifier == 405
            self.name = "Tree 5"
            self.parent = [0,1,2,3,3,2,6,6,6,1,10,10,11,12,12,12]
            self.children = Children(self.parent)
            self.state = [7.0 12.0 14.0 15.0 13.0 9.0 11.0 10.0 8.0 4.0 6.0 2.0 5.0 0.0 1.0 3.0]'
            self.probability = [1.0 0.7 0.4 0.7 0.3 0.6 0.2 0.3 0.5 0.3 0.2 0.8 1.0 0.3 0.5 0.2]'
        end
        return self
    end

    """
    	Tree(bstructure::Vector{Int64}, dimension=Int64[])

    Returns a tree according to the specified branching vector and the dimension.

    Args:
    bstructure - the branching structure of the scenario tree.
    dimension - describes how many values (states) in each node.

    The branching vector must start with 1 for the root node.
    """
    function Tree(bstructure::Vector{Int64}, dimension=Int64[])
        self = new()
        if isempty(dimension)
            dimension = 1
        end
        leaves = bstructure
        for stage = 1 : length(bstructure)
            if stage == 1
                leaves = 1
                self.name = "Tree $(bstructure[1])"
                self.parent = zeros(Int64, bstructure[1])
                self.children = Children(self.parent)
                self.state = randn(rng, bstructure[1], dimension)
                self.probability = ones(bstructure[1], 1)
            else
                leaves = leaves * bstructure[stage-1]
                newleaves = vec(ones(Int64, bstructure[stage]) .* transpose(length(self.parent) .+ (1 .- leaves : 0)))
                self.parent =  vcat(self.parent, newleaves)
                self.children = Children(self.parent)
                self.state = vcat(self.state, randn(length(newleaves), dimension))
                self.name = "$(self.name)x$(bstructure[stage])"
                tmp = rand(rng, Uniform(0.3, 1.0), bstructure[stage], leaves)
                tmp = tmp ./ (transpose(ones(1, bstructure[stage])) .* sum(tmp, dims = 1))
                self.probability = vcat(self.probability, vec(tmp))
            end
        end
        return self
    end
end

"""
	stage(trr::Tree, node=Int64[])

Returns the stage of each node in the tree.

Args:
trr - an instance of a Tree.
node - the number of node in the scenario tree you want to know its stage.
"""
function stage(trr::Tree, node = Int64[])
    if isempty(node)
        node = 1 : length(trr.parent)
    elseif isa(node, Int64)
        node = Int64[node]
    end
    #stage = zeros(length(collect(node))) #you can also use this
    stage = zero(node)
    for i = 1 : length(node)
        pred = node[i]
        while pred > 0 && trr.parent[pred] > 0
            pred = trr.parent[pred]
            stage[i] += 1
        end
    end
    return stage
end

"""
	height(trr::Tree)

Returns the height of the tree which is just the maximum number of the stages of each node.

Args:
trr - an instance of a Tree.
"""
function height(trr::Tree)
    return maximum(stage(trr))
end

"""
	leaves(trr::Tree,node=Int64[])

Returns the leaf nodes, their indexes and the conditional probabilities.

Args:
trr - an instance of a Tree.
node - a node in the tree you want to its children.
"""
function leaves(trr::Tree, node = Int64[])
    nodes = 1 : length(trr.parent)
    leaves = setdiff(nodes, trr.parent)
    #leaves are all nodes which are not parents
    #setdiff(A,B) finds all the elements that belongs to A and are not in B
    omegas = 1 : length(leaves)
    if !isempty(node) && isa(node,Int64)
        node = Int64[node]
    end
    if !isempty(node) && (0 ∉ node)
        omegas = Set{Int64}()
        nodes = leaves
        while any(j !=0 for j ∈ nodes)
            omegas = union(omegas, (ind for (ind, j) ∈ enumerate(nodes) if j ∈ node))
            nodes = Int64[trr.parent[max(0 , j)] for j ∈ nodes]
        end
        omegas = collect(omegas)
    end
    leaves = Int64[leaves[j] for j ∈ omegas]
    prob = ones(Float64 , length(leaves))
    nodes = leaves
    while any(j !=0 for j ∈ nodes)
        prob = prob .* trr.probability[[j for j in nodes]]
        nodes = Int64[trr.parent[max(0 , j)] for j ∈ nodes]
    end
    return leaves, omegas, prob
end

"""
	nodes(trr::Tree,t=Int64[])

Returns the nodes in the tree, generally the range of the nodes in the tree.

Args:
trr - an instance of a Tree.
t  - stage in the tree.

Example : nodes(trr,2) - gives all nodes at stage 2.
"""
function nodes(trr::Tree, t = Int64[])
    nodes = 1 : length(trr.parent)
    if isempty(t) #if stage t is not given, return all nodes of the tree
        return nodes
    else # else return nodes at the given stage t
        stg = stage(trr)
        return Int64[i for i in nodes if stg[i] == t]
    end
end

"""
	root(trr::Tree,nodes=Int64[])
Returns the root of the tree if the node is not specified.

Args:
trr - an instance of Tree.
nodes - node in the tree you want to know the sequence from the root.

If `nodes` is not specified, it returns the root of the tree.
If `nodes` is specified, it returns a sequence of nodes from the root to the specified node.
"""
function root(trr::Tree, nodes = Int64[])
    if isempty(nodes)
        nodes = trr.children[1]
    elseif isa(nodes , Int64)
        nodes = Int64[nodes]
    end
    root = 1 : length(trr.parent)
    for i in nodes
        iroot = Vector{Int64}([])
        tmp = i
        while tmp > 0
            push!(iroot , tmp)
            tmp = trr.parent[tmp]
        end
        root = Int64[i for i in reverse(iroot) if i in root]
    end
    return root
end

"""
	partTree(trr::Tree)

Returns a vector of trees in d-dimension.

Args:
trr - an instance of Tree.
"""
function partTree(trr::Tree)
    trees = Tree[]
    for col = 1:size(trr.state , 2)
        subtree = Tree("Tree of state $col", trr.parent, trr.children, hcat(trr.state[:,col]), trr.probability)
        push!(trees,subtree)
    end
    return trees
end

"""
	buildProb!(trr::Tree,probabilities::Array{Float64,2})

Returns the probabilities of the nodes without probabilities
if the array of probabilities is less than the length of parents
in the stochastic approximation procedure.
"""
function buildProb!(trr::Tree, probabilities::Array{Float64,2})
    leaf, omegas, probaLeaf = leaves(trr)
    if length(probabilities) == length(nodes(trr))
        trr.probability .= probabilities
    else
        probabilities .= max.(0.0,probabilities)
        j = leaf; i = trr.parent[j]; j .= j[i .> 0]; i .= i[i .> 0]
        trr.probability .= zeros(length(trr.state[:,1]), 1)
        trr.probability[j] = probabilities
        while !isempty(i)
            for k = 1:length(i)
                trr.probability[i[k]] = trr.probability[i[k]] + trr.probability[j[k]]
            end
            trr.probability[j] .= trr.probability[j] ./ trr.probability[i]
            trr.probability[isnan.(trr.probability)] .= 0.0
            j = unique(i); i = trr.parent[j]; j = j[i .> 0] ; i = i[i .> 0]
        end
    end
    return trr.probability
end

"""
	treeplot(trr::Tree,fig=1)

Returns the plot of the input tree annotated with density of
probabilities of reaching the leaf nodes in the tree.
"""
function treeplot(trr::Tree, fig= 1)
    if !isempty(fig)
        figure(fig)
    end
    #suptitle(trr.name, fontsize = 14)
    trs = subplot2grid((1,4), (0,0), colspan=3)
    title("states")
    stg = stage(trr)
    xticks(1 : height(trr) + 1)         # Set the ticks on the x-axis
    xlabel("stage,time",fontsize=12)
    trs.spines["top"].set_visible(false)         # remove the line of the box at the top
    trs.spines["right"].set_visible(false)		 # remove the line of the box at the right
    for i = 1 : length(trr.parent)
        if stg[i] > 0
            trs.plot([stg[i],stg[i]+1],[trr.state[trr.parent[i]],trr.state[i]],linewidth=1.5)
        end
    end
    prs = subplot2grid((1,4), (0,3))
    title("probabilities")
    prs.spines["top"].set_visible(false)
    prs.spines["left"].set_visible(false)
    prs.spines["right"].set_visible(false)

    (Yi,_,probYi) = leaves(trr)
    Yi = [trr.state[i] for i in Yi]
    nY = length(Yi)
    h = 1.05 * std(Yi) / (nY^0.2) + 1e-3         #Silverman rule of thumb
    #trs.set_ylim(minimum(Yi)-h, maximum(Yi)+h)
    #prs.set_ylim(minimum(Yi)-h, maximum(Yi)+h)
    yticks(())                                                                                                             #remove the ticks on probability plot
    t = LinRange(minimum(Yi)-h, maximum(Yi)+h, 100)  #100 points on probability plot
    density = zero(t)
    for (i, ti) in enumerate(t)
        for (j, xj) in enumerate(Yi)
            tmp = (xj - ti) / h
            density[i] += probYi[j]* 35/32 * max(1.0 -tmp^2, 0.0)^3 /h #triweight kernel
        end
    end
    plot(density, t)
    prs.fill_betweenx(t, 0 , density)
end

"""
	plotD(newtree::Tree)

returns a plots of trees in higher dimensions.
"""
function plotD(newtree::Tree)
    fig = figure(figsize = (10,6))
    stg = stage(newtree)
    for rw = 1:size(newtree.state,2)
      ax = subplot(1,size(newtree.state,2),rw)
      ax.spines["top"].set_visible(false)                                                  #remove the box top
      ax.spines["right"].set_visible(false)                                               #remove the box right
      for i in range(1,stop = length(newtree.parent))
          if stg[i] > 0
              ax.plot([stg[i], stg[i]+1],[newtree.state[:,rw][newtree.parent[i]], newtree.state[:,rw][i]])
          end
          xlabel("stage, time")
          ylabel("states")
      end
      xticks(unique(stg))
    end
end
