module ScenTrees
include("TreeStructure.jl")
include("StochApproxTree.jl")
include("StochPaths.jl")
include("LatticeApprox.jl")
export StochApproximation!,LatticeApproximation,Tree,stage,height,leaves,nodes,root,
		partTree,buildProb!,treeplot,plotD,PlotLattice,GaussianSamplePath,RunningMaximum
end
