### A Pluto.jl notebook ###
# v0.19.42

#> [frontmatter]
#> order = "20"
#> title = "Visits"

using Markdown
using InteractiveUtils

# ╔═╡ c6f49bb2-783a-11ee-0151-47703d60127f
begin
    using Pkg
    Pkg.activate(Base.current_project("."))
    Pkg.instantiate()
end

# ╔═╡ f082a987-c9b6-4330-812c-f1a7aa4cfb13
begin
    using Dates
    using FunSQL
    using PlutoUI
    using DataFrames
    using HypertextLiteral
    using CSV
    using Revise
    using TRDW
end

# ╔═╡ 95a93876-78af-40a1-b55f-24062f7eddb0
begin
    TRDW.NotebookHeader("TRDW — Visit Exploration")
end

# ╔═╡ 2a8772f8-a803-4fc5-90cc-ba1a9ef023f6
md"""In the TRDW, visit records come from Epic and various historical sources. The following visit concepts are used."""

# ╔═╡ d858cfa7-f0a0-4616-86da-9cebb90c6d65
md"""
## Appendix

Notebook implementation details.
"""

# ╔═╡ b00d388f-cf21-49c6-a985-2e011b8913b3
begin
    DATA_WAREHOUSE = "ctsi.trdw_green" # shifted dates/times but no other PHI
    @connect DATA_WAREHOUSE
end

# ╔═╡ d2462cf5-0881-4d66-9943-2b7f40137566
@query begin
    visit()
    count_concept()
end

# ╔═╡ c7a0850c-b83e-468c-9a46-75186dc7ad2d
TRDW.NotebookFooter()

# ╔═╡ Cell order:
# ╟─95a93876-78af-40a1-b55f-24062f7eddb0
# ╟─2a8772f8-a803-4fc5-90cc-ba1a9ef023f6
# ╠═d2462cf5-0881-4d66-9943-2b7f40137566
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╠═c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
# ╟─c7a0850c-b83e-468c-9a46-75186dc7ad2d
