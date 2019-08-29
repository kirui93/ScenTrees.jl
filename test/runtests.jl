using ScenTrees
using Test

@testset "ScenTrees.jl" begin
	@testset "ScenTrees.jl - Stochastic Approximation" begin
	    paths = [GaussianSamplePath,RunningMaximum]
	    trees = [Tree([1,2,2]),Tree([1,3,3])]
	    samplesize = 10000
	    pNorm = 2
	    rWasserstein = 2

	    for path in paths
		for newtree in trees
		    StochApproximation!(newtree,path,samplesize,pNorm,rWasserstein)
		    @test length(newtree.parent) == length(newtree.state)
		    @test length(newtree.parent) == length(newtree.probability)
		    @test length(stage(newtree)) == length(newtree.parent)
		    @test height(newtree) == maximum(stage(newtree))
		end
	    end
	end
	
	@testset "Lattice Approximation" begin
		tstLat = LatticeApproximation([1,2,3,4,5],500000)
		@test length(tstLat.state) == length(tstLat.probability)
	end
end
