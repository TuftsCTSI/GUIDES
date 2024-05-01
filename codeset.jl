### A Pluto.jl notebook ###
# v0.19.38

#> [frontmatter]
#> order = "99"
#> title = "Minimal Notebook"

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
    const TITLE = "N3C Recommended Codesets"
    const NOTE = "Tufts Research Data Warehouse (TRDW) Guides & Demos"
    const IRB = 11642
    export TITLE, NOTE, CASE, SFID, IRB
    TRDW.NotebookHeader(TITLE; NOTE)
end

# ╔═╡ d858cfa7-f0a0-4616-86da-9cebb90c6d65
md"""
## Appendix

Notebook implementation details.
"""

# ╔═╡ b00d388f-cf21-49c6-a985-2e011b8913b3
@connect "ctsi.codeset" "ctsi.trdw_green" # shifted dates/times but no other PHI

# ╔═╡ 9a9f06ba-07b9-4d73-b7ff-e680f5ced07b
df = @query from(codeset).filter(is_n3c_recommended == 1)

# ╔═╡ f980f781-c1f8-4e9c-bd22-cac6fb1dbd16
begin
	titles = []
	for d in eachrow(df.ref.x)
		push!(titles, @htl("""
		<div>
		<details>
			<summary>
				<b>$(d["concept_set_name"]):</b> 
				<p><b>$(d["number_concepts"])</b> concepts</p>
			</summary>
			<h3>$(d["concept_set_name"])</h3>
			<h4>Intention</h4>
			<p>$(d["codeset_intention"])</p>
			<h4>Limitations</h4>
			<p>$(d["limitations"])</p>
			<h4>Number concepts: $(d["number_concepts"])</h4>
		</details>
		</div>
		"""))
	end
	@htl "$titles"
end

# ╔═╡ Cell order:
# ╠═95a93876-78af-40a1-b55f-24062f7eddb0
# ╟─f980f781-c1f8-4e9c-bd22-cac6fb1dbd16
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╠═9a9f06ba-07b9-4d73-b7ff-e680f5ced07b
# ╠═c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
