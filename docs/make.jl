using ConstrainedPlanarTriangles
using Documenter

DocMeta.setdocmeta!(ConstrainedPlanarTriangles, :DocTestSetup, :(using ConstrainedPlanarTriangles); recursive=true)

makedocs(;
    modules=[ConstrainedPlanarTriangles],
    authors="Thomas Poulsen <ta.poulsen@gmail.com> and contributors",
    repo="https://github.com/tp2750/ConstrainedPlanarTriangles.jl/blob/{commit}{path}#{line}",
    sitename="ConstrainedPlanarTriangles.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://tp2750.github.io/ConstrainedPlanarTriangles.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tp2750/ConstrainedPlanarTriangles.jl",
    devbranch="main",
)
