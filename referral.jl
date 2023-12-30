### A Pluto.jl notebook ###
# v0.19.32

#> [frontmatter]
#> order = "3"
#> title = "Patient Referrals"

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
# Querying Patient Referral Data

This notebook outlines the handling of patient referrals in the Tufts Research Data Warehouse (TRDW).

"""

# ╔═╡ e2b098ec-5afd-427a-a34b-cae768a35008
md"""All patient referral records coming from Epic Clarity are mapped to the same SNOMED code regardless of the department to where they are referring the patient"""

# ╔═╡ 67f8a286-cfc6-4f75-a87c-9d0d1ebccf84
referral_concepts = @concepts begin
    patient_referral = [SNOMED(3457005, "Patient referral")]
end

# ╔═╡ 40083ddf-9f11-401e-a046-e2f03f94b05c
md"""
> As of now, patient referrals are not being captured from Soarian or other legacy data sources"""

# ╔═╡ ae690146-918a-4223-b2a1-1d6acad00983
md"""
### Querying by "referred-to" department

The department to which a patient was referred is captured in the observation record in the __value\_as\_string__ column:
"""

# ╔═╡ 9e0c1ceb-21b2-455a-8b0b-2458eb67abf8
md"""
> Note that "referred-to" department names either start with a number or the phrase "Referral Provider Specialty".
>
> This signifies whether the specialty of the department/provider being referred to was taken directly from the source record or inferred from the specialty of the provider listed.
"""

# ╔═╡ 466e70b2-ac30-4545-ba54-ec9fe47f9824
md"""
Since "reffered-to" values are not mapped to the OMOP vocabulary, we filter referrals using string matching:
"""

# ╔═╡ d858cfa7-f0a0-4616-86da-9cebb90c6d65
md"""## Appendix
"""

# ╔═╡ aaca8900-9cb4-4438-a18b-0f576b144d84
TRDW.funsql_export()

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


# ╔═╡ 2961fb72-cc3a-4e72-b5fb-c7f0e4086cb1
@query observation($referral_concepts).group(pre_epic => observation_id > 1500000000).define(count())

# ╔═╡ 0e1f40c4-085a-4597-9fe4-a80b03204a0d
@query begin
    observation($referral_concepts)
	group(observation_concept_id, value_as_string)
	define(n_referrals_to_dept => count())
	order(count().desc())
end

# ╔═╡ 1ff00dca-7c61-4582-aaba-19e09c2cd46b
@query begin
    observation($referral_concepts)
	filter(icontains(value_as_string, "card"))
	group(observation_concept_id, value_as_string)
	define(n_referrals_to_dept => count())
	order(count().desc())
end

# ╔═╡ 87f6fa05-6806-4044-b88f-ff447144ffa9
macro aquery(q)
    :(TRDW.run($db, @funsql $q; annotate_keys=true))
end

# ╔═╡ Cell order:
# ╟─95a93876-78af-40a1-b55f-24062f7eddb0
# ╟─e2b098ec-5afd-427a-a34b-cae768a35008
# ╠═67f8a286-cfc6-4f75-a87c-9d0d1ebccf84
# ╠═2961fb72-cc3a-4e72-b5fb-c7f0e4086cb1
# ╟─40083ddf-9f11-401e-a046-e2f03f94b05c
# ╟─ae690146-918a-4223-b2a1-1d6acad00983
# ╠═0e1f40c4-085a-4597-9fe4-a80b03204a0d
# ╟─9e0c1ceb-21b2-455a-8b0b-2458eb67abf8
# ╠═466e70b2-ac30-4545-ba54-ec9fe47f9824
# ╠═1ff00dca-7c61-4582-aaba-19e09c2cd46b
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╟─c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═f082a987-c9b6-4330-812c-f1a7aa4cfb13
# ╠═aaca8900-9cb4-4438-a18b-0f576b144d84
# ╠═756b56b0-a735-4ef8-a41f-c38112acda2c
# ╠═b00d388f-cf21-49c6-a985-2e011b8913b3
# ╠═d4242e16-d8cf-46da-b707-5a9ff9efe1f2
# ╠═f171861f-fe0d-4976-861c-c28ab6e27101
# ╠═87f6fa05-6806-4044-b88f-ff447144ffa9
