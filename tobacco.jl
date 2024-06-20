### A Pluto.jl notebook ###
# v0.19.42

#> [frontmatter]
#> order = "51"
#> title = "Tobacco"

using Markdown
using InteractiveUtils

# ╔═╡ c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═╡ show_logs = false
begin
    using Pkg
    Pkg.activate(Base.current_project("."))
    Pkg.instantiate()
end

# ╔═╡ f082a987-c9b6-4330-812c-f1a7aa4cfb13
begin
    using FunSQL
    using TRDW
	using HypertextLiteral
	using PlutoUI
	using DataFrames
end

# ╔═╡ 0db1f701-47e3-4755-b0d5-0b39a5fd1dbb
TRDW.NotebookHeader("TRDW — Tobacco")

# ╔═╡ 5fe23636-10fe-42e8-8814-3247211e3299
## Accessing Tobacco Data in TRDW

# ╔═╡ 64cae773-0478-4ec8-8a8c-c07a294fea92
### Intermediate Model Tables

# ╔═╡ 47385f71-c39d-4018-a4a3-fe4f88d9a525
#### Composite (Epic and Legacy)

# ╔═╡ 40a3df08-9841-465d-9d87-ba31cb58d2bd
##### SOCIAL_HX_FULL

# ╔═╡ d92682b0-4271-49c9-a25e-8398c004a109
##### SDD_DATA_FULL

# ╔═╡ afd86b45-7276-4b3f-9f90-c4929abb258e
#### Epic-sourced

# ╔═╡ d4ecf815-a8c3-48f9-bcf2-537c0c68e2cc
##### SOCIAL_HX - Tobacco Subset

# ╔═╡ b602fc4d-7e08-41af-b591-a6169e444346
##### SDD_DATA - Tobacco Subset

# ╔═╡ 189ac0d0-acf1-4d9a-8140-2d2441c9b52b
#### Legacy-sourced

# ╔═╡ 8f451a1a-ca46-4cc4-9de4-c07775bf9c21
##### Soarian Diagnoses - Tobacco Subset

# ╔═╡ f4e7e7f7-c6c1-4118-87ab-9e5b8060fc34
##### Soarian Observations - Tobacco Subset

# ╔═╡ d858cfa7-f0a0-4616-86da-9cebb90c6d65
md"""## Appendix
"""

# ╔═╡ b00d388f-cf21-49c6-a985-2e011b8913b3
begin
    DATA_WAREHOUSE = "ctsi.trdw_green" # shifted dates/times but no other PHI
    @connect DATA_WAREHOUSE
end

# ╔═╡ f171861f-fe0d-4976-861c-c28ab6e27101
TRDW.NotebookFooter()

# ╔═╡ Cell order:
# ╠═0db1f701-47e3-4755-b0d5-0b39a5fd1dbb
# ╠═5fe23636-10fe-42e8-8814-3247211e3299
# ╠═64cae773-0478-4ec8-8a8c-c07a294fea92
# ╠═47385f71-c39d-4018-a4a3-fe4f88d9a525
# ╠═40a3df08-9841-465d-9d87-ba31cb58d2bd
# ╠═d92682b0-4271-49c9-a25e-8398c004a109
# ╠═afd86b45-7276-4b3f-9f90-c4929abb258e
# ╠═d4ecf815-a8c3-48f9-bcf2-537c0c68e2cc
# ╠═b602fc4d-7e08-41af-b591-a6169e444346
# ╠═189ac0d0-acf1-4d9a-8140-2d2441c9b52b
# ╠═8f451a1a-ca46-4cc4-9de4-c07775bf9c21
# ╠═f4e7e7f7-c6c1-4118-87ab-9e5b8060fc34
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╠═c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
# ╟─f171861f-fe0d-4976-861c-c28ab6e27101
