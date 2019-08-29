module ScenTrees
include("TreeStructure.jl")
include("TreeApprox.jl")
include("StochPaths.jl")
include("LatticeApprox.jl")
export TreeApproximation!,LatticeApproximation,Tree,Lattice,stage,height,leaves,nodes,root,
        partTree,buildProb!,treeplot,plotD,PlotLattice,GaussianSamplePath,RunningMaximum

"""
	Tree()
Returns a tree with the name,parents of nodes, children of the parents, states of the nodes and probabilities of transition.
Note that it takes a vector of integers

Fox example, Tree([1,2,3,4])
"""

"""
	stage()

Returns the stage of each node in the tree.
"""

"""
	height()

Returns the height of the tree
"""

"""
	leaves()

Returns the leaves of the tree and their unconditional probabilities
"""

"""
	nodes()

Returns the nodes of the tree
"""

"""
	root()

Returns the root (parent of all nodes) of the tree.
It also returns a sequence of nodes to reach a specific node.

For example;

root(d,5)

Returns a sequence of nodes to reach node 5 in tree d
"""

"""
	GaussianSamplePath()

Returns samples from the Gaussian Random Walk
"""

"""
	RunningMaximum()

Returns the maximum of consecutive numbers from the Gaussian distribution
"""


"""
	TreeApproximation!()

Returns a valuated probability scenario tree. Note that the inputs are in the following order: Tree(), path, sample size, 2,2
"""

"""
	LatticeApproximation

Returns a valuated scanario lattice. It takes as inputs a vector of branching structure and the sample size.
"""
end
