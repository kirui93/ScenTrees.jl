module ScenTrees
include("TreeStructure.jl")
include("TreeApprox.jl")
include("StochPaths.jl")
include("LatticeApprox.jl")
include("KernelDensityEstimation.jl")
include("bushinessNesDistance.jl")
export tree_approximation!,lattice_approximation,Tree,Lattice,stage,height,leaves,nodes,root,
        part_tree,build_probabilities!,tree_plot,plot_hd,plot_lattice,gaussian_path1D,gaussian_path2D,
        running_maximum1D,running_maximum2D,path,bushiness_nesdistance,kernel_scenarios
end
