### A Pluto.jl notebook ###
# v0.19.38

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
    const TITLE = "Visit Exploration"
	const STUDY = "Tufts Research Data Warehouse / Guides & Demos"
    const CASE = "01000526"
    const SFID = "5008Y00002NhtQ5QAJ"
	const IRB = 11642
	export TITLE, STUDY, CASE, SFID, IRB
    TRDW.NotebookHeader(TITLE; STUDY, CASE, SFID, IRB)
end

# ╔═╡ 2a8772f8-a803-4fc5-90cc-ba1a9ef023f6
md"""Let's look at the various types of visits."""

# ╔═╡ 075d9ffa-c976-4af7-9e0a-8bd519812860
md"""It seems hard to know exactly which visits might be for primary care."""

# ╔═╡ 8c2c163a-8116-4c4a-9f29-9de2db1b6a9a
TRDW.funsql_export()

# ╔═╡ 70d4d76a-554a-4748-a946-695769c4621b
md"""We could break this down by category of office, hospital, and other"""

# ╔═╡ 4b11dc23-00fd-4eaf-a4a4-e6417eafd246
visit_concepts = @concepts begin
    primary = [ primary_visit ]
    hospital = [
        CMS_Place_of_Service("OMOP4822036","Observation Room"),
        Visit("ER","Emergency Room Visit"),
        Visit("IP","Inpatient Visit"),
        Visit("ERIP","Emergency Room and Inpatient Visit")
    ]
    hospice = [
        CMS_Place_of_Service("34","Hospice"),
        NUCC("315D00000X","Inpatient Hospice"),
    ]
    labs = [
        Visit("OMOP4822461","Laboratory Visit"),
    ]
    pharmacy = [
        Visit("OMOP4822462","Pharmacy visit"),
    ]
    other = [
        NUCC("261Q00000X", "Ambulatory Clinic / Center"),
    ]
    outpatient = [
        # this double-counts many of the above due to OP
        Visit("OP","Outpatient Visit"),
    ]
end

# ╔═╡ 618042b4-fad9-4c47-98d7-58cd59752e41
md"""Are there visits that fail to match these categories?"""

# ╔═╡ 6c7c85b0-8b93-4607-8cd6-840b1e3c2b48
md"""Telehealth and home visits are not (currently) categorized as outpatient visits."""

# ╔═╡ 5e335c74-abb2-4963-a50b-6bb2e73b53c2
md"""What sort of visit concepts are neither outpatient nor hospital?"""

# ╔═╡ 56b6c042-c72a-4e94-8d33-c86f26e4d8f2
md"""For historical (Soarian) or current (EPIC) data, what is the breakdown by concept set? """

# ╔═╡ 513d889d-c4c6-45c9-9e63-fd1d6508b7c6
md"""Visit detail is less populated."""

# ╔═╡ cb0e1f12-a71a-4d77-99d6-9e889834da63
md"""Perhaps care site might let us find primary care practices?"""

# ╔═╡ b26b8597-95d8-4050-a8ec-afa754399c71
md"""We could look at visits by care site."""

# ╔═╡ 21c74148-fe3f-4185-bd0c-ce168d405dae
md"""Perhaps the place of service might be useful?"""

# ╔═╡ 0ff2b608-e1e6-4206-acc2-ac4f0a7868f9
md"""Let's look at a few care sites with names that seem like they may do primary care."""

# ╔═╡ 80de563c-9f6e-4be9-ba08-19178e99d40f
@funsql rounded_count(threshold) = begin
    filter(count()> $threshold)
    order(count().desc())
    define(n_visit => roundups(count()))
end

# ╔═╡ d49ebd20-f986-4ed8-92c7-e7a56d56f0e9
md"""Perhaps physician specialty might help us find primary care visits?"""

# ╔═╡ f848d8c4-1480-48d8-a963-ae8fb6af3e34
md"""How does specialty correlate with the kind of visit?"""

# ╔═╡ 80ffbc9e-1d97-46ea-8a5e-168f5b1d3b66
md"""Sometimes the visit detail has more information."""

# ╔═╡ 67b624ac-12ca-48b2-b64d-856af4a750ed
md"""Perhaps something useful is stored in visit_source"""

# ╔═╡ e0ea032b-d7fb-43c9-afd2-80fb1c8ed16e
md"""How about the specialty source concept?"""

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

# ╔═╡ aa95371e-b3bf-4b42-88fb-d74d03975d36
@query concept().filter(domain_id == "Visit" && standard_concept == "S").group(concept_name).filter(count()>1).define(collect_to_string(vocabulary_id))

# ╔═╡ 70a3e08b-c622-42d6-b282-43289e2b922a
@query Visit("Telehealth")

# ╔═╡ d13c0aa4-b0da-42f6-82db-bb30541a01f9
primary_visit = @query append(
        Visit("Telehealth"),
        Visit("Independent Clinic"),
        Visit("Clinic or Group Practice"),
        Visit("Home Visit"),
        Visit("Office Visit"),
        Visit("Health examination"))

# ╔═╡ edf8c6c4-b4c6-4db9-bb56-0d5d5b7a647d
@query begin
    visit()
    filter(!concept_matches($visit_concepts))
    count_concept()
end

# ╔═╡ 96cca9f0-5bf7-4755-97f4-9a4a44b747b6
@query begin
    concept()
    filter(concept_matches($primary_visit) || concept_matches(Visit("OP", "Outpatient Visit")))
    filter_out_descendants()
end

# ╔═╡ 710a22cc-d38c-498a-a4ea-75fbd6c61a18
@query begin
    visit()
    filter(concept_matches($visit_concepts))
    group(concept_id)
    filter(!concept_matches(Visit("OP"), Visit("ER"), Visit("IP"), Visit("ERIP")))
    select_concept()
end

# ╔═╡ ee2618bb-29e5-4866-91f6-0fca32a3ec26
@query begin
    visit()
    define(ext.is_preepic)
    define(visit_name =>
        replace(type_concept.concept_name, "Visit derived from ", ""))
    concept_set_pivot($visit_concepts; group=[is_preepic, visit_name])
end

# ╔═╡ 87bc697d-f238-4a7b-8e44-545e133f64be
@query begin
    visit_detail()
    define(ext.is_preepic)
    define(visit_name =>
        replace(type_concept.concept_name, "Visit derived from ", ""))
    concept_set_pivot($visit_concepts; group=[is_preepic, visit_name])
end

# ╔═╡ 04076e79-2e2a-49eb-acc1-bec1defdee30
@query begin
    care_site()
    group(concept_id, ext.is_preepic)
    select_concept(concept_id, is_preepic, count())
    order(count.desc())
end

# ╔═╡ 8db3cb79-8e98-475f-b485-0a370a2432b6
@query begin
    visit()
    define(ext.is_preepic)
    define(care_site.care_site_name)
    concept_set_pivot($visit_concepts; group=[is_preepic, care_site_name])
end

# ╔═╡ a91d84d7-a569-46bf-940f-d9d2dd30e407
@query begin
    visit()
    define(ext.is_preepic)
    define(care_site.concept.concept_name)
    concept_set_pivot($visit_concepts; group=[is_preepic, concept_name])
end

# ╔═╡ 21a3e508-9daf-4fe1-8b99-01bf29e12c4d
@query begin
    care_site()
    define(by_name => icontains(care_site_name,
        "primary care", "gen med", "family medicine", "internal medicine",
        "medical associates", "pediatrics", "medical group"))
    join(v => visit($primary_visit, Visit("OP")), v.care_site_id == care_site_id)
    group(ext.is_preepic, by_name, care_site_name, concept.concept_name)
    rounded_count(10000)
end

# ╔═╡ ee09b084-6118-47ea-bed3-949c4e68734b
@query begin
    visit($primary_visit, Visit("OP"))
    filter(ext.is_preepic)
    group(speciality => provider.concept.concept_name)
    rounded_count(10000)
end

# ╔═╡ d972ce8f-edfc-4adc-91f7-da206196de77
@query begin
    visit($primary_visit, Visit("OP"))
    filter(!ext.is_preepic)
    group(speciality => provider.concept.concept_name)
    rounded_count(1000)
end

# ╔═╡ 91e24f57-dc24-45f5-86f0-16d8c1284c6c
@query begin
    visit($primary_visit, Visit("OP"))
    group(provider.concept_id)
    select_concept(concept_id, count => roundups(count()); order=[count().desc()])
end

# ╔═╡ c69054d6-9c7e-4df3-b9ae-74a82b11ae56
@query begin
    visit($primary_visit, Visit("OP"))
    group(speciality => provider.concept.concept_name, visit_concept => concept.concept_name, ext.is_preepic)
    rounded_count(10000)
end

# ╔═╡ add69180-b3ca-4a12-8722-7be9389ab04c
@query begin
    visit_detail($primary_visit, Visit("OP"))
    group(speciality => provider.concept.concept_name, visit_concept => concept.concept_name, ext.is_preepic)
    rounded_count(1000)
end

# ╔═╡ a84c9b8b-eab4-4e07-b298-23ccd389d38d
@query begin
    visit($primary_visit, Visit("OP"))
    group(omop.visit_source_value, ext.is_preepic)
    rounded_count(1000)
end

# ╔═╡ 97e05b97-40cc-4f76-84d8-5d60d582e5d3
@query begin
    visit_detail($primary_visit, Visit("OP"))
    group(provider.omop.specialty_source_value, ext.is_preepic)
    rounded_count(1000)
end

# ╔═╡ 3ca33947-ada6-4fae-890f-82f9c7ca7c22
@query begin
    visit_detail($primary_visit, Visit("OP"))
    group(concept_id => provider.omop.specialty_source_concept_id, ext.is_preepic)
    select_concept(concept_id, count => roundups(count()), is_preepic; order=[count().desc()])
end

# ╔═╡ c7a0850c-b83e-468c-9a46-75186dc7ad2d
TRDW.NotebookFooter(; CASE, SFID)

# ╔═╡ Cell order:
# ╟─95a93876-78af-40a1-b55f-24062f7eddb0
# ╟─2a8772f8-a803-4fc5-90cc-ba1a9ef023f6
# ╠═d2462cf5-0881-4d66-9943-2b7f40137566
# ╟─075d9ffa-c976-4af7-9e0a-8bd519812860
# ╠═aa95371e-b3bf-4b42-88fb-d74d03975d36
# ╠═8c2c163a-8116-4c4a-9f29-9de2db1b6a9a
# ╠═70a3e08b-c622-42d6-b282-43289e2b922a
# ╠═d13c0aa4-b0da-42f6-82db-bb30541a01f9
# ╟─70d4d76a-554a-4748-a946-695769c4621b
# ╠═4b11dc23-00fd-4eaf-a4a4-e6417eafd246
# ╟─618042b4-fad9-4c47-98d7-58cd59752e41
# ╠═edf8c6c4-b4c6-4db9-bb56-0d5d5b7a647d
# ╟─6c7c85b0-8b93-4607-8cd6-840b1e3c2b48
# ╠═96cca9f0-5bf7-4755-97f4-9a4a44b747b6
# ╟─5e335c74-abb2-4963-a50b-6bb2e73b53c2
# ╠═710a22cc-d38c-498a-a4ea-75fbd6c61a18
# ╟─56b6c042-c72a-4e94-8d33-c86f26e4d8f2
# ╠═ee2618bb-29e5-4866-91f6-0fca32a3ec26
# ╟─513d889d-c4c6-45c9-9e63-fd1d6508b7c6
# ╠═87bc697d-f238-4a7b-8e44-545e133f64be
# ╟─cb0e1f12-a71a-4d77-99d6-9e889834da63
# ╠═04076e79-2e2a-49eb-acc1-bec1defdee30
# ╟─b26b8597-95d8-4050-a8ec-afa754399c71
# ╠═8db3cb79-8e98-475f-b485-0a370a2432b6
# ╟─21c74148-fe3f-4185-bd0c-ce168d405dae
# ╠═a91d84d7-a569-46bf-940f-d9d2dd30e407
# ╟─0ff2b608-e1e6-4206-acc2-ac4f0a7868f9
# ╠═21a3e508-9daf-4fe1-8b99-01bf29e12c4d
# ╠═80de563c-9f6e-4be9-ba08-19178e99d40f
# ╟─d49ebd20-f986-4ed8-92c7-e7a56d56f0e9
# ╠═ee09b084-6118-47ea-bed3-949c4e68734b
# ╠═d972ce8f-edfc-4adc-91f7-da206196de77
# ╠═91e24f57-dc24-45f5-86f0-16d8c1284c6c
# ╟─f848d8c4-1480-48d8-a963-ae8fb6af3e34
# ╠═c69054d6-9c7e-4df3-b9ae-74a82b11ae56
# ╟─80ffbc9e-1d97-46ea-8a5e-168f5b1d3b66
# ╠═add69180-b3ca-4a12-8722-7be9389ab04c
# ╟─67b624ac-12ca-48b2-b64d-856af4a750ed
# ╠═a84c9b8b-eab4-4e07-b298-23ccd389d38d
# ╠═97e05b97-40cc-4f76-84d8-5d60d582e5d3
# ╟─e0ea032b-d7fb-43c9-afd2-80fb1c8ed16e
# ╠═3ca33947-ada6-4fae-890f-82f9c7ca7c22
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╠═c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
# ╟─c7a0850c-b83e-468c-9a46-75186dc7ad2d
