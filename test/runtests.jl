using ScenTrees
using Test

@testset "ScenTrees.jl" begin
    @testset "A sample of a Scenario Tree 1D" begin
        x = Tree([1,3,3,3,3],1)
        @test typeof(x) == Tree
        @test length(x.parent) == 121
        @test length(x.state) == length(x.probability) == length(x.parent) == 121
        @test sum(x.probability) \approx 41.0
        @test length(x.children) == 41
    end
    @testset "A sample of a Scenario Tree 2D" begin
        y = Tree([1,3,3,3,3],2)
        @test typeof(y) == Tree
        @test length(y.parent) == 121
        @test length(y.probability) == length(y.parent) == 121
        @test length(y.state) == length(y.parent)*2 == 242
        @test sum(y.probability) \approx 41.0
        @test length(y.children) == 41
    end
    @testset "ScenTrees.jl - Tree Approximation 1D" begin
        paths = [GaussianSamplePath1D,RunningMaximum1D]
        trees = [Tree([1,2,2,2]),Tree([1,3,3,3])]
        samplesize = 100000
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
    @testset "ScenTrees.jl - Tree Approximation 2D" begin
        twoD= TreeApproximation!(Tree([1,3,3,3],2),GaussianSamplePath2D,100000,2,2)
        @test size(twoD.state,2) == 2
        @test size(twoD.state,1) == length(twoD.parent) == length(twoD.probability)
    end

    @testset "ScenTree.jl - Lattice Approximation" begin
        tstLat = LatticeApproximation([1,2,3,4],GaussianSamplePath1D,500000)
        @test length(tstLat.state) == length(tstLat.probability)
        @test round.([sum(tstLat.probability[i]) for i=1:length(tstLat.probability)], digits = 1)  == [1.0,1.0,1.0,1.0] #sum of probs at every stage
    end
end
