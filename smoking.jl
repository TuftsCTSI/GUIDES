### A Pluto.jl notebook ###
# v0.19.38

#> [frontmatter]
#> order = "50"
#> title = "Smoking Behavior"

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

# ╔═╡ 0db1f701-47e3-4755-b0d5-0b39a5fd1dbb
begin
    const TITLE = "TRDW — Smoking Behavior"
    const NOTE = "Tufts Research Data Warehouse (TRDW) Guides & Demos"
    const CASE = "01000526"
    const SFID = "5008Y00002NhtQ5QAJ"
    const IRB = 11642
    export TITLE, NOTE, CASE, SFID, IRB
    TRDW.NotebookHeader(TITLE; NOTE, CASE, SFID)
end

# ╔═╡ afe5e914-2e19-4d22-ac09-332b1575e87d
md"""The recommended OHDSI vocabulary concept for representing smoking data is OMOP Extension, [903652](https://athena.ohdsi.org/search-terms/terms/903652)."""

# ╔═╡ 6e614fcc-21b0-472d-a2b3-8eee52f5831c
md"""We can once again count the observations of this concept and its descendants."""

# ╔═╡ 36c01c9d-a1e4-4d8e-82b3-d0f9f6d04d92
md"""For these observations, the actual smoking behavior is often found in the `value_as_concept_id` field."""

# ╔═╡ e08fe4c9-40a0-4b95-956d-7874c386556b
md"""Some of these findings might not have a corresponding `value_as_concept_id`"""

# ╔═╡ 8d42b408-3432-4f2c-8f85-d40f81014f94
md"""We could construct a value set of concepts that match smoking behavior..."""

# ╔═╡ 31734392-7731-4fd9-8a5e-6ecf45181dee
md"""#### Exploring OMOP Extension `findings_of_tobacco`."""

# ╔═╡ d858cfa7-f0a0-4616-86da-9cebb90c6d65
md"""## Appendix
"""

# ╔═╡ b00d388f-cf21-49c6-a985-2e011b8913b3
begin
    DATA_WAREHOUSE = "ctsi.trdw_green" # shifted dates/times but no other PHI
    @connect DATA_WAREHOUSE
end

# ╔═╡ e2a29e89-036d-4d6d-9176-8c0ec666f87c
@query begin
    observation()
    filter(icontains(concept.concept_name, "smoking", "smoke", "tobacco"))
    count_concept()
end

# ╔═╡ 2674b4c6-9dfe-42c4-9915-e9a873d89241
findings_of_tobacco = @query OMOP_Extension("Findings of tobacco or its derivatives use or exposure")

# ╔═╡ d2e766e1-33eb-4bf8-8027-918228503973
@query begin
    observation()
    filter(concept_matches($findings_of_tobacco))
    count_concept()
end

# ╔═╡ e1cec40e-393b-449b-840f-31af11276b5f
@query begin
    observation()
    filter(concept_matches($findings_of_tobacco))
    define(primary_concept => concept.concept_name)
    count_concept(value_as_concept_id, primary_concept)
end

# ╔═╡ 0575f567-30c1-4d3f-a091-046d82492104
@query begin
    observation()
    define(source_value => omop.observation_source_value)
    filter(concept_matches($findings_of_tobacco))
    filter((is_null(value_as_concept_id) || value_as_concept_id == 0))
    count_concept(value_as_concept_id, value_as_string, value_as_number, source_value)
end


# ╔═╡ eab365a6-d117-435a-8813-e8e0b2d4f9b6
smoking_behavior = @query concept_sets(
    smoker = [
        OMOP_Extension("Cigar smoker"),
        OMOP_Extension("Cigarette smoker"),
        OMOP_Extension("Electronic cigarette smoker"),
        OMOP_Extension("Hookah smoker"),
        OMOP_Extension("Passive smoker"),
        OMOP_Extension("Pipe smoker")]
)

# ╔═╡ 6a704eb8-ddd5-4a7d-a5b9-8f017b5e575a
@query $findings_of_tobacco.concept_children()

# ╔═╡ 8f6374e2-e8b1-4d26-b341-5fd19c17af40
@query OMOP_Extension("Currently doesn't use tobacco or its derivatives").concept_children()

# ╔═╡ 517b0d43-971e-43d3-aaec-18be5afcd587
@query OMOP_Extension("Tobacco or its derivatives user").concept_children()

# ╔═╡ 4192e5e2-3fb8-4550-a9d6-387209fda461
@query OMOP_Extension("Cigarette smoker").concept_children()

# ╔═╡ f171861f-fe0d-4976-861c-c28ab6e27101
TRDW.NotebookFooter(; CASE, SFID)

# ╔═╡ Cell order:
# ╟─0db1f701-47e3-4755-b0d5-0b39a5fd1dbb
# ╠═e2a29e89-036d-4d6d-9176-8c0ec666f87c
# ╟─afe5e914-2e19-4d22-ac09-332b1575e87d
# ╠═2674b4c6-9dfe-42c4-9915-e9a873d89241
# ╟─6e614fcc-21b0-472d-a2b3-8eee52f5831c
# ╠═d2e766e1-33eb-4bf8-8027-918228503973
# ╟─36c01c9d-a1e4-4d8e-82b3-d0f9f6d04d92
# ╠═e1cec40e-393b-449b-840f-31af11276b5f
# ╟─e08fe4c9-40a0-4b95-956d-7874c386556b
# ╠═0575f567-30c1-4d3f-a091-046d82492104
# ╟─8d42b408-3432-4f2c-8f85-d40f81014f94
# ╠═eab365a6-d117-435a-8813-e8e0b2d4f9b6
# ╟─31734392-7731-4fd9-8a5e-6ecf45181dee
# ╠═6a704eb8-ddd5-4a7d-a5b9-8f017b5e575a
# ╠═8f6374e2-e8b1-4d26-b341-5fd19c17af40
# ╠═517b0d43-971e-43d3-aaec-18be5afcd587
# ╠═4192e5e2-3fb8-4550-a9d6-387209fda461
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╠═c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
# ╟─f171861f-fe0d-4976-861c-c28ab6e27101
