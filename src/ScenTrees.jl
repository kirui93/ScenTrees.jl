module ScenTrees
include("TreeStructure.jl")
include("TreeApprox.jl")
include("StochPaths.jl")
include("LatticeApprox.jl")
export TreeApproximation!,LatticeApproximation,Tree,Lattice,stage,height,leaves,nodes,root,
        partTree,buildProb!,treeplot,plotD,PlotLattice,GaussianSamplePath,RunningMaximum


"""
	GaussianSamplePath()

Returns samples from the Gaussian Random Walk
"""

"""
	RunningMaximum()

Returns the maximum of consecutive numbers from the Gaussian distribution
"""

end
