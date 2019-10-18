module ScenTrees
include("TreeStructure.jl")
include("TreeApprox.jl")
include("StochPaths.jl")
include("LatticeApprox.jl")
include("KernelDensityEstimation.jl")
include("bushinessNesDistance.jl")
include("SomeData.jl")
export TreeApproximation!,LatticeApproximation,Tree,Lattice,stage,height,leaves,nodes,root,
        partTree,buildProb!,treeplot,plotD,PlotLattice,GaussianSamplePath1D,GaussianSamplePath2D,
        RunningMaximum1D,RunningMaximum2D,path,bushinessNesDistance,LogisticKernel,KernelScenarios,
        gsData,df1,df22,RWData
end
