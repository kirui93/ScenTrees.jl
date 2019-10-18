using ScenTrees
using Test
using Statistics: std

@testset "ScenTrees.jl" begin
    @testset "A sample of a Scenario Tree 1D" begin
        x = Tree([1,3,3,3,3],1)
        @test typeof(x) == Tree
        @test length(x.parent) == 121
        @test length(x.state) == length(x.probability) == length(x.parent) == 121
        @test sum(x.probability) ≈ 41.0
        @test length(x.children) == 41
    end
    @testset "A sample of a Scenario Tree 2D" begin
        y = Tree([1,3,3,3,3],2)
        @test typeof(y) == Tree
        @test length(y.parent) == 121
        @test length(y.probability) == length(y.parent) == 121
        @test length(y.state) == length(y.parent)*2 == 242
        @test sum(y.probability) ≈ 41.0
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
        @test round.(sum.(tstLat.probability), digits = 1)  == [1.0, 1.0, 1.0, 1.0] #sum of probs at every stage
    end
    @testset "ScenTrees.jl - Test Example Data" begin
        @test size(gsData) ==(100,10)
        @test size(df1) == (1000,7)
        @test size(df22) == (1000,4)
        @test size(RWData) == (1000,5)
    end
    @testset "ScenTrees.jl - Test Standard deviations" begin
        sd1 = zeros(5)
        sd2 = zeros(7)
        for t = 1:size(RWData,2)
            sd1[t] = std(RWData[:,t])
        end
        for t = 1:size(df1,2)
            sd2[t] = std(df1[:,t])
        end
        @test (sd1 .< 5) == Bool[true, true, true, true, true]
        @test (sd2 .< 10) == Bool[true, true, true, true, true, true, true]
    end
    @testset "ScenTrees.jl - Test Kernel trajectory creation" begin
        a = KernelScenarios(gsData)
        b = KernelScenarios(df1)
        c = KernelScenarios(df22)
        d = KernelScenarios(RWData)
        @test length(a()) == length(gsData,2)
        @test length(b()) == length(df1,2)
        @test length(c()) == length(df22,2)
        @test length(d()) == length(RWData,2)
    end
    @testset "ScenTrees.jl - Test Kernel Lattice creation" begin
        LatFromKernel = LatticeApproximation([1,3,4,5,6],KernelScenarios(RWData),100000)
        @test round.(sum.(LatFromKernel.probability),digits=1) == [1.0, 1.0, 1.0, 1.0, 1.0]
        @test length(LatFromKernel.state) == length(LatFromKernel.probability)
    end
end
