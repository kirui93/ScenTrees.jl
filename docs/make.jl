using Documenter, ScenTrees

makedocs(
	sitename =  "ScenTrees.jl",
	authors = "Kipngeno Kirui",
	clean = false,
	doctest = true,
	format = Documenter.HTML(
		assets = ["exampleTree1.png",
		          "Tree402.pdf",
		          "Tree4022.pdf",
		          "treeapprox1.pdf",
		          "treeapprox2D.pdf",
		          "ExampleLattice2.pdf",
		          "LatticeApprox.pdf"
		          ],
		prettyurls = get(ENV, "CI", nothing) == "true"),
	pages = ["Home" => "index.md",
			"Tutorials" => Any["tutorial/tutorial1.md",
			                    "tutorial/tutorial2.md",
			                    "tutorial/tutorial3.md",
			                    "tutorial/tutorial4.md"]
			                    ]
)

deploydocs(deps = Deps.pip("mkdocs","python-markdown-math"),
	repo="github.com/kirui93/ScenTrees.jl.git"
)
