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

# ╔═╡ 1c70715b-85e0-483a-98cb-0f11c0bc06a9
@query from(codeset_expression).filter(codeset_id == 106000255).limit(100)

# ╔═╡ a0c28148-e8f8-4ef1-b7a5-aea58e41bc0f
xf = @query concept(
	concept_id == 4125593
).limit(10)

# ╔═╡ de70824c-deee-4b88-9f09-7be7a95a2320
"""$(xf.ref.x[!, "vocabulary_id"][1])("$(xf.ref.x[!, "concept_code"][1])", $(xf.ref.x[!, "concept_name"][1]))"""

# ╔═╡ 962c15d8-16d6-41b5-a6c7-f54bfdfcb483
dd = @query concept_sets(
	p = SNOMED("289203002", "Finding of pattern of pregnancy")
)

# ╔═╡ d6840fd8-879c-47bb-853c-322e26d5db9a
dump(dd)

# ╔═╡ 8a8c87b0-6ea3-4def-b115-a149da63386f
ddd = @query concept(
			concept_id == 4125593
		).concept_children()

# ╔═╡ 239c8f1f-2709-4db0-8d6d-36bbe8a98645
for r in eachrow(ddd.ref.x)
	print(r["concept_id"])
end

# ╔═╡ 4faa997b-2ae1-4440-887e-66d87b8d2e26
dump(ddd)

# ╔═╡ 024b5bd5-1e7a-48a1-83a6-081d47ff0c7c
@query from(codeset_expression).filter(is_n3c_recommended == 1).limit(100)

# ╔═╡ 9a9f06ba-07b9-4d73-b7ff-e680f5ced07b
df = @query begin
	from(codeset)
	filter(is_n3c_recommended == 1)
	left_join(r => from(researcher), r.researcher_id == codeset_created_by)
	define(
		r.researcher_name,
		r.institution,
		r.orcid_id
	)
end

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
			<div style="border:solid #E5E5E5;margin-bottom:10px;padding:20px;background-color:#FEFCF5;">
				<h3>$(d["concept_set_name"])</h3>
				<h4>Codeset author: </h4>
				<p>$(d["researcher_name"]) ($(d["orcid_id"]), $(d["institution"]))</p>
				<h4>Intention</h4>
				<p>$(d["codeset_intention"])</p>
				<h4>Limitations</h4>
				<p>$(d["limitations"])</p>
				<h4>Number concepts: $(d["number_concepts"])</h4>
			</div>
		</details>
		</div>
		"""))
	end
	@htl "$titles"
end

# ╔═╡ Cell order:
# ╠═95a93876-78af-40a1-b55f-24062f7eddb0
# ╠═f980f781-c1f8-4e9c-bd22-cac6fb1dbd16
# ╠═1c70715b-85e0-483a-98cb-0f11c0bc06a9
# ╠═a0c28148-e8f8-4ef1-b7a5-aea58e41bc0f
# ╠═239c8f1f-2709-4db0-8d6d-36bbe8a98645
# ╠═962c15d8-16d6-41b5-a6c7-f54bfdfcb483
# ╠═4faa997b-2ae1-4440-887e-66d87b8d2e26
# ╠═d6840fd8-879c-47bb-853c-322e26d5db9a
# ╠═de70824c-deee-4b88-9f09-7be7a95a2320
# ╠═8a8c87b0-6ea3-4def-b115-a149da63386f
# ╠═024b5bd5-1e7a-48a1-83a6-081d47ff0c7c
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╠═9a9f06ba-07b9-4d73-b7ff-e680f5ced07b
# ╠═c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
