using WebAssemblyText
using Documenter

makedocs(;
    modules=[WebAssemblyText],
    authors="Anders Gustafsson <andersgee@gmail.com> and contributors",
    repo="https://github.com/andersgee/WebAssemblyText.jl/blob/{commit}{path}#L{line}",
    sitename="WebAssemblyText.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://andersgee.github.io/WebAssemblyText.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/andersgee/WebAssemblyText.jl",
)
