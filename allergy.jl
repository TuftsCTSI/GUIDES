### A Pluto.jl notebook ###
# v0.19.32

#> [frontmatter]
#> order = "3"
#> title = "Querying Allergy Data"

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
    using FunSQL
    using PlutoUI
    using DataFrames
    using CSV
    using Revise
    using TRDW
    TRDW.wide_notebook_style
end

# ╔═╡ 756b56b0-a735-4ef8-a41f-c38112acda2c
using TRDW: OMOP_Extension, LOINC, SNOMED

# ╔═╡ 95a93876-78af-40a1-b55f-24062f7eddb0
md"""
# Querying Allergy Data

This notebook outlines allergy handling in the Tufts Research Data Warehouse (TRDW).

"""

# ╔═╡ 9e6aae7c-7368-4857-8fad-514fe76ff572
md"""#### Soarian: Tufts Medical Center before April 1st 2022"""

# ╔═╡ 8067ceff-9ef6-49a8-ae8c-712bc885a8a8
md"""Allergy records are represented as observations with SNOMED `609328004|Allergic disposition`."""

# ╔═╡ 7a64e871-2b1d-4758-a57f-add08101feb7
@funsql allergies() = observation(SNOMED(609328004, "Allergic disposition"))

# ╔═╡ 6e614fcc-21b0-472d-a2b3-8eee52f5831c
md"""Alergies are often indexed as RxNorm ingredients."""

# ╔═╡ 33eb276d-319c-4135-b910-5f4fab9f001e
allergens = @concepts begin
    penicillins = drug_ingredient_via_NDFRT("N0000011281", "Penicillins")
end

# ╔═╡ 0ced86b0-2e52-4ca3-aca8-b09fd7feaa4a
md"""They are enumerated by maching on the `value_as_concept_id` column"""

# ╔═╡ bd890e7a-5259-4548-948b-3809bd6319b0
md"""> Our Soarian data currently fails to map categories of allergies, such as penicillins."""

# ╔═╡ 740db90e-4f2b-428f-9bee-f480cc9c2e55
md"""#### EPIC: Tufts Medicine, after April 1st 2022"""

# ╔═╡ 52643fd2-6ac6-430e-a5eb-28607a8d87a7
md"""For EPIC data, allergies are represented as observations with decendants of the following concepts."""

# ╔═╡ 7bd3797a-fc9d-4d02-8667-e42d7ab38794
allergy_concepts = @concepts begin
	alergic_disorder = [SNOMED(781474001, "Allergic disorder")]
	propensity_to_reaction = [SNOMED(420134006, "Propensity to adverse reaction")]
	hypersensitivity = [SNOMED(609406000, "Non-allergic hypersensitivity reaction")]
end

# ╔═╡ 6c6ef658-9fe5-4c67-8f49-283fc0acbf72
md"""There is an exception for penicillins which are mapped explicitly."""

# ╔═╡ b3515114-c908-4b26-bdab-1adc0c93bff3
md"""The current algorithem for mapping EPIC allergies first matches on "allergy to" concepts, then rounds up to standard concepts. Here we make sure that our `allergy_concepts` covers those that are mapped."""

# ╔═╡ d858cfa7-f0a0-4616-86da-9cebb90c6d65
md"""## Appendix
"""

# ╔═╡ b00d388f-cf21-49c6-a985-2e011b8913b3
DATA_WAREHOUSE = "ctsi.trdw_merge" # Both Soarian and Epic Data

# ╔═╡ d4242e16-d8cf-46da-b707-5a9ff9efe1f2
begin
    db = TRDW.connect_with_funsql(DATA_WAREHOUSE)
    nothing
end

# ╔═╡ f171861f-fe0d-4976-861c-c28ab6e27101
macro query(q)
    :(TRDW.run($db, @funsql $q))
end


# ╔═╡ e2a29e89-036d-4d6d-9176-8c0ec666f87c
@query allergies().group().select(count())

# ╔═╡ 0e1f40c4-085a-4597-9fe4-a80b03204a0d
 @query begin
	allergies()
	filter(concept_matches($allergens; match_prefix=value_as_concept_id))
	count_concept(value_as_concept_id)
end

# ╔═╡ 266d3efe-ef06-4539-ac14-840bb778cd0b
@query observation($allergy_concepts).group().define(count())

# ╔═╡ 11448962-a8e3-4df7-b29c-785838aafb2f
@query observation(SNOMED(91936005, "Allergy to penicillin")).group().define(count())

# ╔═╡ a925f6c2-a29b-4966-b5a7-2e94bd05b404
@query begin
	concept()
	filter(vocabulary_id == "SNOMED" && domain_id == "Observation" && ilike(concept_name, "allergy to %"))
	concept_relatives("Maps to")
	define(isa_allergy => concept_matches($allergy_concepts))
	filter(!isa_allergy)
end

# ╔═╡ Cell order:
# ╟─95a93876-78af-40a1-b55f-24062f7eddb0
# ╟─9e6aae7c-7368-4857-8fad-514fe76ff572
# ╟─8067ceff-9ef6-49a8-ae8c-712bc885a8a8
# ╠═7a64e871-2b1d-4758-a57f-add08101feb7
# ╠═e2a29e89-036d-4d6d-9176-8c0ec666f87c
# ╟─6e614fcc-21b0-472d-a2b3-8eee52f5831c
# ╠═33eb276d-319c-4135-b910-5f4fab9f001e
# ╟─0ced86b0-2e52-4ca3-aca8-b09fd7feaa4a
# ╠═0e1f40c4-085a-4597-9fe4-a80b03204a0d
# ╟─bd890e7a-5259-4548-948b-3809bd6319b0
# ╟─740db90e-4f2b-428f-9bee-f480cc9c2e55
# ╟─52643fd2-6ac6-430e-a5eb-28607a8d87a7
# ╠═7bd3797a-fc9d-4d02-8667-e42d7ab38794
# ╠═266d3efe-ef06-4539-ac14-840bb778cd0b
# ╟─6c6ef658-9fe5-4c67-8f49-283fc0acbf72
# ╠═11448962-a8e3-4df7-b29c-785838aafb2f
# ╟─b3515114-c908-4b26-bdab-1adc0c93bff3
# ╠═a925f6c2-a29b-4966-b5a7-2e94bd05b404
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╟─c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═756b56b0-a735-4ef8-a41f-c38112acda2c
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
# ╠═d4242e16-d8cf-46da-b707-5a9ff9efe1f2
# ╠═f171861f-fe0d-4976-861c-c28ab6e27101
