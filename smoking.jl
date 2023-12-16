### A Pluto.jl notebook ###
# v0.19.32

#> [frontmatter]
#> order = "3"
#> title = "Querying Smoking Behavior"

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
using TRDW: OMOP_Extension, LOINC

# ╔═╡ 95a93876-78af-40a1-b55f-24062f7eddb0
md"""
# Querying Smoking Behavior

This notebook outlines smoking observations in the Tufts Research Data Warehouse (TRDW). We start by listing observations for smoking and tobacco concepts.
"""

# ╔═╡ afe5e914-2e19-4d22-ac09-332b1575e87d
md"""The recommended OHDSI vocabulary concept for representing smoking data is OMOP Extension, [903652](https://athena.ohdsi.org/search-terms/terms/903652)."""

# ╔═╡ 2674b4c6-9dfe-42c4-9915-e9a873d89241
findings_of_tobacco = OMOP_Extension(nothing, "Findings of tobacco or its derivatives use or exposure")

# ╔═╡ 6e614fcc-21b0-472d-a2b3-8eee52f5831c
md"""We can once again count the observations of this concept and its descendants."""

# ╔═╡ 36c01c9d-a1e4-4d8e-82b3-d0f9f6d04d92
md"""For these observations, the actual smoking behavior is often found in the `value_as_concept_id` field."""

# ╔═╡ e08fe4c9-40a0-4b95-956d-7874c386556b
md"""Some of these findings might not have a corresponding `value_as_concept_id`"""

# ╔═╡ 8d42b408-3432-4f2c-8f85-d40f81014f94
md"""We could construct a value set of concepts that match smoking behavior..."""

# ╔═╡ eab365a6-d117-435a-8813-e8e0b2d4f9b6
smoking_behavior = @concepts begin
    smoker = [
        OMOP_Extension("OMOP5181846","Cigar smoker"),
        OMOP_Extension("OMOP5181838","Cigarette smoker"),
        OMOP_Extension("OMOP5181836","Electronic cigarette smoker"),
        OMOP_Extension("OMOP5181847","Hookah smoker"),
        OMOP_Extension("OMOP5181837","Passive smoker"),
        OMOP_Extension("OMOP5181845","Pipe smoker")]
end

# ╔═╡ 31734392-7731-4fd9-8a5e-6ecf45181dee
md"""#### Exploring OMOP Extension `findings_of_tobacco`."""

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
@query begin
    concept()
    filter(icontains(concept_name, "smoking", "smoke", "tobacco"))
    join(obs => begin
        observation()
        group(observation_concept_id)
    end, concept_id == obs.observation_concept_id)
    define(n_event => obs.count())
    define(n_person => obs.count_distinct(person_id))
    order(n_person.desc())
    select(n_person => roundups(n_person), concept_id, vocabulary_id, concept_class_id, concept_code, concept_name)
end

# ╔═╡ d2e766e1-33eb-4bf8-8027-918228503973
@query begin
    observation()
    filter(observation_matches($findings_of_tobacco))
    count_concept(observation_concept_id)
end

# ╔═╡ e1cec40e-393b-449b-840f-31af11276b5f
@query begin
    observation()
    filter(observation_matches($findings_of_tobacco))
    group(observation_concept_id, value_as_concept_id)
    define(n_event => count())
    left_join(main => concept(), main.concept_id == observation_concept_id)
    left_join(value => concept(), value.concept_id == value_as_concept_id)
    order(isnull(value.vocabulary_id), n_event.desc())
    select(n_event => roundups(n_event),
        observation_concept_id, observation_concept => concat(left(main.concept_name, 19), "..."),
        value.concept_id, value.vocabulary_id, value.concept_code, value.concept_name)
end

# ╔═╡ 0575f567-30c1-4d3f-a091-046d82492104
@query begin
    observation()
    filter(observation_concept_id == $findings_of_tobacco &&
           (is_null(value_as_concept_id) || value_as_concept_id == 0))
    group(value_as_concept_id, value_as_string, value_as_number, observation_source_value)
    define(n_event => roundups(count()))
end


# ╔═╡ 6a704eb8-ddd5-4a7d-a5b9-8f017b5e575a
@query concept($findings_of_tobacco).concept_children()

# ╔═╡ 8f6374e2-e8b1-4d26-b341-5fd19c17af40
@query concept(OMOP_Extension(nothing, "Currently doesn't use tobacco...")).concept_children()

# ╔═╡ 517b0d43-971e-43d3-aaec-18be5afcd587
@query concept(OMOP_Extension(nothing, "Tobacco or its derivatives user")).concept_children()

# ╔═╡ 4192e5e2-3fb8-4550-a9d6-387209fda461
@query concept(OMOP_Extension(nothing, "Cigarette smoker")).concept_children()

# ╔═╡ Cell order:
# ╟─95a93876-78af-40a1-b55f-24062f7eddb0
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
# ╟─c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═756b56b0-a735-4ef8-a41f-c38112acda2c
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
# ╠═d4242e16-d8cf-46da-b707-5a9ff9efe1f2
# ╠═f171861f-fe0d-4976-861c-c28ab6e27101
