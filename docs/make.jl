using Documenter, ScenTrees

makedocs(
	sitename =  "ScenTrees.jl",
	authors = "Kipngeno Kirui",
	clean = true,
	doctest = true,
	format = Documenter.HTML(
		assets = ["exampleTree1.png"],
		prettyurls = get(ENV, "CI", nothing) == "true"),
	pages = [ "Home" => "index.md",
			"Tutorials" => "tutorial/tutorial1.md"],
)

deploydocs(deps = Deps.pip("mkdocs","python-markdown-math"),
			repo="github.com/kirui93/ScenTrees.jl.git"
			make = () -> run(`mkdocs build`),
			target = "site"
)
