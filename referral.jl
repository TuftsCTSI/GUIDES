### A Pluto.jl notebook ###
# v0.19.42

#> [frontmatter]
#> order = "30"
#> title = "Patient Referrals"

using Markdown
using InteractiveUtils

# ╔═╡ c6f49bb2-783a-11ee-0151-47703d60127f
begin
    using Pkg
    Pkg.activate(Base.current_project("."))
    Pkg.instantiate()
end

# ╔═╡ d4242e16-d8cf-46da-b707-5a9ff9efe1f2
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
TRDW.NotebookHeader("TRDW — Patient Referrals")

# ╔═╡ e2b098ec-5afd-427a-a34b-cae768a35008
md"""All patient referral records coming from Epic Clarity are mapped to the same SNOMED code regardless of the department to where they are referring the patient"""

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

# ╔═╡ f171861f-fe0d-4976-861c-c28ab6e27101
begin
    DATA_WAREHOUSE = "ctsi.trdw_green" # shifted dates/times but no other PHI
    @connect DATA_WAREHOUSE
end

# ╔═╡ 67f8a286-cfc6-4f75-a87c-9d0d1ebccf84
referral_concepts = @query concept_sets(
    patient_referral = [SNOMED(3457005, "Patient referral")]
)

# ╔═╡ 2961fb72-cc3a-4e72-b5fb-c7f0e4086cb1
@query observation($referral_concepts).group(ext.is_preepic).define(roundups(count()))

# ╔═╡ 0e1f40c4-085a-4597-9fe4-a80b03204a0d
@query begin
    observation($referral_concepts)
    group(concept_id, value_as_string)
    order(count().desc())
    define(n_referrals_to_dept => roundups(count()))
end

# ╔═╡ 1ff00dca-7c61-4582-aaba-19e09c2cd46b
@query begin
    observation($referral_concepts)
    filter(icontains(value_as_string, "card"))
    group(concept_id, value_as_string)
    order(count().desc())
    define(n_referrals_to_dept => roundups(count()))
end

# ╔═╡ 87f6fa05-6806-4044-b88f-ff447144ffa9
TRDW.NotebookFooter()

# ╔═╡ Cell order:
# ╟─95a93876-78af-40a1-b55f-24062f7eddb0
# ╟─e2b098ec-5afd-427a-a34b-cae768a35008
# ╠═67f8a286-cfc6-4f75-a87c-9d0d1ebccf84
# ╠═2961fb72-cc3a-4e72-b5fb-c7f0e4086cb1
# ╟─40083ddf-9f11-401e-a046-e2f03f94b05c
# ╟─ae690146-918a-4223-b2a1-1d6acad00983
# ╠═0e1f40c4-085a-4597-9fe4-a80b03204a0d
# ╟─9e0c1ceb-21b2-455a-8b0b-2458eb67abf8
# ╟─466e70b2-ac30-4545-ba54-ec9fe47f9824
# ╠═1ff00dca-7c61-4582-aaba-19e09c2cd46b
# ╟─d858cfa7-f0a0-4616-86da-9cebb90c6d65
# ╟─c6f49bb2-783a-11ee-0151-47703d60127f
# ╠═d4242e16-d8cf-46da-b707-5a9ff9efe1f2
# ╠═f171861f-fe0d-4976-861c-c28ab6e27101
# ╟─87f6fa05-6806-4044-b88f-ff447144ffa9
