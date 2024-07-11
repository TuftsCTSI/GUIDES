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
TRDW.NotebookHeader("TRDW — Alcohol")

# ╔═╡ 5fe23636-10fe-42e8-8814-3247211e3299
md"""## Accessing Tobacco Data in TRDW"""

# ╔═╡ 64cae773-0478-4ec8-8a8c-c07a294fea92
md"""### Intermediate Model Tables"""

# ╔═╡ 47385f71-c39d-4018-a4a3-fe4f88d9a525
md"""#### Composite (Epic and Legacy)"""

# ╔═╡ 40a3df08-9841-465d-9d87-ba31cb58d2bd
md"""##### SHX"""

# ╔═╡ 348ec5c2-1e2d-406d-8533-d1e2fecf4f69
@funsql shx_alcohol() = from(shx_alcohol)

# ╔═╡ d92682b0-4271-49c9-a25e-8398c004a109
md"""##### SDD\_DATA\_FULL"""

# ╔═╡ afd86b45-7276-4b3f-9f90-c4929abb258e
md"""#### Epic-sourced"""

# ╔═╡ d4ecf815-a8c3-48f9-bcf2-537c0c68e2cc
md"""##### SOCIAL\_HX - Tobacco Subset"""

# ╔═╡ 1457935b-7cfd-498b-9817-6d5629214d84
@funsql shx_epic_alcohol() = from(shx_epic_alcohol)

# ╔═╡ b602fc4d-7e08-41af-b591-a6169e444346
md"""##### SDD\_DATA - Tobacco Subset"""

# ╔═╡ 189ac0d0-acf1-4d9a-8140-2d2441c9b52b
md"""#### Legacy-sourced"""

# ╔═╡ 6f6f5744-e575-4e57-b1f9-828137a6a38c
md"""
##### Soarian SHX - Tobacco Subset
"""

# ╔═╡ 37743ca6-8cd7-406e-8bcd-15da65da7366
@funsql shx_soarian_alcohol() = from(shx_soarian_alcohol)

# ╔═╡ 8f451a1a-ca46-4cc4-9de4-c07775bf9c21
md"""##### Soarian Diagnoses - Tobacco Subset

This table is formatted in three ways: legacy, social_hx, and sdd"""

# ╔═╡ 0df53a61-3f39-4d94-aad0-00150883e6f5
begin
	@funsql soarian_alcohol_dx() = from(soarian_alcohol_dx)
	@funsql shx_soarian_alcohol_dx() = from(shx_soarian_alcohol_dx)
end

# ╔═╡ f4e7e7f7-c6c1-4118-87ab-9e5b8060fc34
md"""##### Soarian Observations - Tobacco Subset"""

# ╔═╡ 2bd2a35c-a347-4f0d-a3ce-defb56a8a4bb
begin
	@funsql soarian_alcohol_obs() = from(soarian_alcohol_obs)
	@funsql shx_soarian_alcohol_obs() = from(shx_soarian_alcohol_obs)
end

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
# ╟─0db1f701-47e3-4755-b0d5-0b39a5fd1dbb
# ╟─5fe23636-10fe-42e8-8814-3247211e3299
# ╟─64cae773-0478-4ec8-8a8c-c07a294fea92
# ╟─47385f71-c39d-4018-a4a3-fe4f88d9a525
# ╟─40a3df08-9841-465d-9d87-ba31cb58d2bd
# ╠═348ec5c2-1e2d-406d-8533-d1e2fecf4f69
# ╟─d92682b0-4271-49c9-a25e-8398c004a109
# ╟─afd86b45-7276-4b3f-9f90-c4929abb258e
# ╟─d4ecf815-a8c3-48f9-bcf2-537c0c68e2cc
# ╠═1457935b-7cfd-498b-9817-6d5629214d84
# ╟─b602fc4d-7e08-41af-b591-a6169e444346
# ╟─189ac0d0-acf1-4d9a-8140-2d2441c9b52b
# ╟─6f6f5744-e575-4e57-b1f9-828137a6a38c
# ╠═37743ca6-8cd7-406e-8bcd-15da65da7366
# ╟─8f451a1a-ca46-4cc4-9de4-c07775bf9c21
# ╠═0df53a61-3f39-4d94-aad0-00150883e6f5
# ╟─f4e7e7f7-c6c1-4118-87ab-9e5b8060fc34
# ╠═2bd2a35c-a347-4f0d-a3ce-defb56a8a4bb
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╠═c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
# ╟─f171861f-fe0d-4976-861c-c28ab6e27101
