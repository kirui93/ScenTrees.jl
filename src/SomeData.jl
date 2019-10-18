# Some examples of data that we can use in the Kernel Density Estimation method

using CSV, DataFrames, XLSX

data = CSV.read("../data/data5.csv")
gsData = Matrix(data)

df = DataFrame(XLSX.readtable("../data/Mappe1.xlsx", "Sheet1")...)
df1 = Matrix(df)
df1 = convert(Array{Float64,2},df1)

df2 = DataFrame(XLSX.readtable("../data/Mappe1.xlsx", "Sheet2")...)
df22 = Matrix(df2)
df22 = convert(Array{Float64,2},df22)

RandomWalkData = CSV.read("../data/RandomDataWalk.csv")
RWData = Matrix(RandomWalkData)
