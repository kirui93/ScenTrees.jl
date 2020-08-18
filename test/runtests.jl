using ScenTrees
using Test
using Statistics: std
using CSV, DataFrames, XLSX

@testset "ScenTrees.jl" begin
    @testset "Predefined tree - Tree 402" begin
        a = Tree(402)
        @test typeof(a) == Tree
        @test length(a.parent) == 15
        @test length(a.state) == length(a.probability) == length(a.parent) == 15
        @test sum(a.probability) == 8.0
        @test length(a.children) == 8
        @test length(root(a)) == 1
    end
    @testset "Initial Trees" begin
        init = Tree([1,2,2,2],1)
        @test typeof(init) == Tree
        @test length(init.parent) == 15
        @test length(init.state) == length(init.probability) == length(init.parent) == 15
        @test length(init.children) == 8
        @test length(stage(init)) == 15
        @test height(init) == 3
        @test length(leaves(init)) == 3
        @test nodes(init) == 1:15
        @test length(nodes(init)) == 15
        @test length(root(init)) == 1
    end
    @testset "A sample of a Scenario Tree 1D" begin
        x = Tree([1,3,3,3,3],1)
        @test typeof(x) == Tree
        @test length(x.parent) == 121
        @test length(x.state) == length(x.probability) == length(x.parent) == 121
        @test sum(x.probability) ≈ 41.0
        @test length(x.children) == 41
        @test length(root(x)) == 1
        @test length(leaves(x)) == 3
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
    @testset "Sample stochastic functions" begin
        a = gaussian_path1D()
        b = running_maximum1D()
        c = path()
        d = gaussian_path2D()
        e = running_maximum2D()
        @test length(a) == 4
        @test length(b) == 4
        @test length(c) == 4
        @test size(d) == (4,2)
        @test size(e) == (4,2)
    end
    @testset "ScenTrees.jl - Tree Approximation 1D" begin
        paths = [gaussian_path1D,running_maximum1D]
        trees = [Tree([1,2,2,2]),Tree([1,3,3,3])]
        samplesize = 100000
        p = 2
        r = 2

        for path in paths
            for newtree in trees
                tree_approximation!(newtree,path,samplesize,p,r)
                @test length(newtree.parent) == length(newtree.state)
                @test length(newtree.parent) == length(newtree.probability)
                @test length(stage(newtree)) == length(newtree.parent)
                @test height(newtree) == maximum(stage(newtree))
                @test round(sum(leaves(newtree)[3]),digits=1) == 1.0   #sum of unconditional probabilities of the leaves
                @test length(root(newtree)) == 1
            end
        end
    end
    @testset "ScenTrees.jl - Tree Approximation 2D" begin
        twoD = tree_approximation!(Tree([1,3,3,3],2),gaussian_path2D,100000,2,2)
        @test size(twoD.state,2) == 2
        @test size(twoD.state,1) == length(twoD.parent) == length(twoD.probability)
    end

    @testset "ScenTrees.jl - Lattice Approximation" begin
        tstLat = lattice_approximation([1,2,3,4],gaussian_path1D,500000,2,1)
        @test length(tstLat.state) == length(tstLat.probability)
        @test round.(sum.(tstLat.probability), digits = 1)  == [1.0, 1.0, 1.0, 1.0] #sum of probs at every stage
    end

    @testset "ScenTrees.jl - Lattice Approximation 2D" begin
        lat2 = lattice_approximation([1,2,3,4],gaussian_path2D,500000,2,2)
        @test length(lat2) == 2 # resultant lattices are 2
        @test length(lat2[1].state) == length(lat2[1].probability)
        @test round.(sum.(lat2[1].probability), digits = 1)  == [1.0, 1.0, 1.0, 1.0]
        @test round.(sum.(lat2[2].probability), digits = 1)  == [1.0, 1.0, 1.0, 1.0]
    end
    @testset "ScenTrees.jl - Test Example Data" begin
        data = CSV.read("data5.csv",DataFrame) # check the new way of loading data
        gsData = Matrix(data)
        df = DataFrame(XLSX.readtable("Mappe1.xlsx", "Sheet1")...)
        df1 = Matrix(df)
        df1 = convert(Array{Float64,2},df1)
        df2 = DataFrame(XLSX.readtable("Mappe1.xlsx", "Sheet2")...)
        df22 = Matrix(df2)
        df22 = convert(Array{Float64,2},df22)
        RandomWalkData = CSV.read("RandomDataWalk.csv",DataFrame)
        RWData = Matrix(RandomWalkData)

        @test size(gsData) ==(100,10)
        @test size(df1) == (1000,7)
        @test size(df22) == (1000,4)
        @test size(RWData) == (1000,5)

        sd1 = zeros(5)
        sd2 = zeros(7)

        for t = 1 : size(RWData,2)
            sd1[t] = std(RWData[:,t])
        end

        for t = 1:size(df1,2)
            sd2[t] = std(df1[:,t])
        end
        @test (sd1 .< 5) == Bool[true, true, true, true, true]
        @test (sd2 .< 10) == Bool[true, true, true, true, true, true, true]

        LatFromKernel = lattice_approximation([1,3,4,5,6],kernel_scenarios(RWData),100000,2,1)
        @test round.(sum.(LatFromKernel.probability),digits=1) == [1.0, 1.0, 1.0, 1.0, 1.0]
        @test length(LatFromKernel.state) == length(LatFromKernel.probability)
    end
end
