using Documenter, ScenTrees

makedocs(
	sitename =  "ScenTrees.jl",
	authors = "Kipngeno Kirui",
	clean = true,
	doctest = true,
	format = Documenter.HTML(
		assets = ["exampleTree1.png",
		          "Tree402.png",
		          "Tree4022.png",
		          "treeapprox1.png",
		          "treeapprox2D.png",
		          "ExampleLattice2.png",
		          "LatticeApprox.png",
			  "diffHeights.png"
		          ],
		prettyurls = get(ENV, "CI", nothing) == "true"),
	pages = ["Home" => "index.md",
			"Tutorials" => Any["tutorial/tutorial1.md",
			                    "tutorial/tutorial2.md",
			                    "tutorial/tutorial3.md",
			                    "tutorial/tutorial4.md",
					    "tutorial/tutorial5.md"]
			                    ]
)

deploydocs(deps = Deps.pip("mkdocs","python-markdown-math"),
	repo="github.com/kirui93/ScenTrees.jl.git"
)
