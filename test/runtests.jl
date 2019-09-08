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
                TreeApproximation!(newtree,path,samplesize,pNorm,rWasserstein)
                @test length(newtree.parent) == length(newtree.state)
                @test length(newtree.parent) == length(newtree.probability)
                @test length(stage(newtree)) == length(newtree.parent)
                @test height(newtree) == maximum(stage(newtree))
                @test round(sum(leaves(newtree)[3]),digits=1) == 1.0   #sum of unconditional probabilities of the leaves
            end
        end
    end

    @testset "ScenTree.jl - Lattice Approximation" begin
        tstLat = LatticeApproximation([1,2,3],GaussianSamplePath,500000,1)
        @test length(tstLat.state) == length(tstLat.probability)
        @test [sum(tstLat.probability[i]) for i=1:length(tstLat.probability)] == Bool[1,1,1] #sum of probs at every stage
    end
end
