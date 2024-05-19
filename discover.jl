### A Pluto.jl notebook ###
# v0.19.42

#> [frontmatter]
#> order = "1"
#> title = "TRDW Overview"

using Markdown
using InteractiveUtils

# ╔═╡ cdb19516-2411-11ee-1c6c-4f2a4b62200a
# ╠═╡ show_logs = false
begin
    using Pkg
    Pkg.activate(Base.current_project("."))
    Pkg.instantiate()
end

# ╔═╡ 8ec6f9c4-2d9c-4e0c-96d3-19012b4f8452
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

# ╔═╡ 5506a86d-5464-403b-99f2-c569ecc8d357
TRDW.NotebookHeader("TRDW — Clinical Data Inventory")

# ╔═╡ f99deebf-880e-43be-9287-71ae128a12ea
md"""This notebook takes the entire TRDW as its cohort, and catalogues various domains by intermediate concepts. For example, diagnosis are catalogued by 3-character ICD10-CM.""" 

# ╔═╡ 92166f39-6a99-403d-aef5-1c9603ef5f78
md"""## Cohort Definition & Summary Counts"""

# ╔═╡ bfa24190-e9a8-44f4-b4b1-2f6473a3619b
md"""
!!! note "Cohort Definition"
    This cohort includes patient records from the Tufts Research Data Warehouse (TRDW) that:
    - have at least one encounter (clinic, emergency, inpatient, prescription) record
"""

# ╔═╡ 9f497e6c-d025-4956-b4e9-16eb3af11452
@funsql index() = visit()

# ╔═╡ 8a5cc3e3-5f68-43da-ba11-cd66ae767eb6
md"""The cohort is defined relative to an *index* event. Sometimes there may be more than one index event, such as a hospitalization or procedure, per patient. In other cases, the number of events is exactly the same as the patient count."""

# ╔═╡ 7993b812-41db-4b26-9599-9c468be8c579
md"""
## Clinical Records

The Tufts Research Data Warehouse (TRDW) normalizes clinical records to fit OHDSI's [common data model](https://www.ohdsi.org/data-standardization/). Clinical records come in many shapes, or *domains*, such as `condition_occurrence` or `drug_exposure`. Each domain has different *attributes*, for example, each drug exposure may have a quantity attribute. Clinical records are indexed by one or more concepts from standard vocabularies, such as SNOMED, RxNorm, CPT, ICD, or LOINC. In the OHDSI model, each domain typically has an attribute for a *standard* concept, suitable for network studies, as well as an attribute for the *source* concept, which is usually how the record was specified in the EHR.
"""

# ╔═╡ faca8760-27dc-4db7-aaeb-66b024e57fb3
md"""
### Condition Occurrence

> The [Condition](https://ohdsi.github.io/CommonDataModel/cdm54.html#CONDITION_OCCURRENCE) domain captures information about a person suggesting the presence of a disease or medical condition stated as a diagnosis, a sign, or a symptom, which is either observed by a provider or reported by the patient.

Here we list the count of clinical diagnosis records, as summarized by 3-character ICD10CM. Some diagnoses which are not codable as ICD use SNOMED. *Here we use the ICD9 to ICD10 General Equivalence Mapping (GEM) so that historical data sources coded with ICD9 could be counted under ICD10 categories.*
"""

# ╔═╡ 5307be8f-68b4-42f7-a95f-b3a659dfe637
md"""
### Device Exposure

> The [Device](https://ohdsi.github.io/CommonDataModel/cdm54.html#DEVICE_EXPOSURE) domain captures information about a person’s exposure to a foreign physical object or instrument which is used for diagnostic or therapeutic purposes through a mechanism beyond chemical action. Devices include implantable objects (e.g. pacemakers, stents, artificial joints), medical equipment and supplies (e.g. bandages, crutches, syringes), other instruments used in medical procedures (e.g. sutures, defibrillators) and material used in clinical care (e.g. adhesives, body material, dental material, surgical material).
"""

# ╔═╡ f4cc1362-2cbb-45af-9837-7a291d939927
md"""
### Drug Exposure

> The [Drug](https://ohdsi.github.io/CommonDataModel/cdm54.html#DRUG_EXPOSURE) domain captures information about a person’s exposure to a medication ingested or otherwise introduced into the body. A Drug is a biochemical substance formulated in such a way that when administered to a person it will exert a certain biochemical effect on the metabolism. Drugs include prescription and over-the-counter medicines, vaccines, and large-molecule biologic therapies. Radiological devices ingested or applied locally do not count as Drugs.
"""

# ╔═╡ 3c8a3ae5-5683-49a3-8de4-fe64eee77c92
md"""Following we list counts of drug exposure records, rounded up to the ingredient level."""

# ╔═╡ db65452a-3dfd-46fc-9203-a746b57f574b
md"""
### Measurements

> The [Measurement](https://ohdsi.github.io/CommonDataModel/cdm54.html#MEASUREMENT) domain captures structured values (numerical or categorical) obtained through systematic and standardized examination or testing of a Person or Person’s sample. Measurements include both orders and results such as laboratory tests, vital signs, quantitative findings from pathology reports, etc. Measurements are stored as attribute value pairs, where the value can be a concept, a string value, or a numerical value with a Unit. Measurements differ from observations in that they require a standardized test or some other activity to generate a quantitative or qualitative result. If there is no result, it is assumed that the lab test was conducted but the result was not captured.
"""

# ╔═╡ cc40c8a0-e775-428c-a535-ebaaa3a0107b
md"""Here we list common measurements, as placed into standard groupings."""

# ╔═╡ 9cfc0ba7-c2cc-4f07-9e32-cd76d5164467
md"""
### Notes

> The [Note](https://ohdsi.github.io/CommonDataModel/cdm54.html#NOTE) domain captures unstructured information that was recorded by a provider about a patient in free text on a given date. Notes include discharge descriptions, imaging results, etc.

"""

# ╔═╡ 67a22c10-d1ae-4c1c-a908-3169f6056643
md"""In the TRDW we have records of some, but not all chart notes."""

# ╔═╡ 6b046afb-220a-43ef-9891-8c1fc87e3054
md"""
### Observations

> The [Observation](https://ohdsi.github.io/CommonDataModel/cdm54.html#OBSERVATION) domain captures clinical facts about a person that is not reflected in other domains. Observations are medical history, family history, social circumstances, lifestyle choices, etc. The datetime recorded reflects when the observation was captured, not necessarily the onset or when the relevant event may have occurred.
"""

# ╔═╡ f4204dc6-5ff0-4993-bb20-3c676d0911dd
md"""
### Procedure Occurrence

> The [Procedure](https://ohdsi.github.io/CommonDataModel/cdm54.html#PROCEDURE) domain captures activities or processes ordered by, or carried out by, a healthcare provider on the patient with a diagnostic or therapeutic purpose. Procedures include surgeries. Lab tests with resulting amount and unit are measurements.

Many procedures are recorded with CPT codes. Epic more granular procedures can be recoded using EAP codes which are not easily mapped onto standard vocabularies. Those are generally not listed in this report.
"""

# ╔═╡ 9a87439b-1f50-40fb-b451-f10e0140c8d9
md"""
### Specimen

> The [Specimen](https://ohdsi.github.io/CommonDataModel/cdm54.html#SPECIMEN) domain captures patient tissue samples.
"""

# ╔═╡ 8da34096-372b-421e-ab29-405aa399b8b7
md"""
### Visits

> The [Visit](https://ohdsi.github.io/CommonDataModel/cdm54.html#VISIT_OCCURRENCE) domain captures events where a person engages with the healthcare system. Visits include office encounters, emergency room visits, admissions, home nursing, etc.
"""

# ╔═╡ 48f17065-25fb-4b85-89dc-15d4e6d5ae0f
md"""Patient encounters that are not selected for return..."""

# ╔═╡ a63c96b8-f70e-47b3-a56d-52419b970975
md"""
## Appendix

Notebook implementation details.
"""

# ╔═╡ a2ed12e7-7591-4a76-a2e3-7e91410c47a3
begin
    DATA_WAREHOUSE = "ctsi.trdw_green" # shifted dates/times but no other PHI
	@connect DATA_WAREHOUSE
end

# ╔═╡ e9eaca17-b929-40c6-971a-6c88f84f80aa
# ╠═╡ skip_as_script = true
#=╠═╡
@query index().cohort_count()
  ╠═╡ =#

# ╔═╡ 3d533264-d93b-4db3-a16d-9dca5c21d28a
# ╠═╡ skip_as_script = true
#=╠═╡
@query index().stratify_by_age()
  ╠═╡ =#

# ╔═╡ a6a28134-c214-49ee-9528-4dab55ae0af9
@query index().stratify_by_sex()

# ╔═╡ b48528d7-d50b-4ea2-96ee-2fbe80f41cae
# ╠═╡ skip_as_script = true
#=╠═╡
@query index().stratify_by_race()
  ╠═╡ =#

# ╔═╡ 7b6fec30-05ca-4be0-8057-2606dc2f75c0
# ╠═╡ skip_as_script = true
#=╠═╡
@query index().stratify_by_ethnicity()
  ╠═╡ =#

# ╔═╡ e3188763-95d7-44ed-8132-8f817d1d91e8
# ╠═╡ skip_as_script = true
#=╠═╡
@query begin
    device()
    group_by_concept(; person_threshold=100)
end
  ╠═╡ =#

# ╔═╡ 004633ce-46fa-40e9-b58b-5a636e9ce2ec
# ╠═╡ skip_as_script = true
#=╠═╡
@query begin
    drug()
    to_ingredient()
    group_by_concept(; person_threshold=100)
	define(concept_code => vocabulary_id == "SPL" ?
	    substring(concept_code, 1, 9) : concept_code)
	format(limit=2000)
end
  ╠═╡ =#

# ╔═╡ dcbe1232-0a75-4297-8635-4cb3e1564146
# ╠═╡ skip_as_script = true
#=╠═╡
@query begin
    measurement()
    truncate_to_cpt4_hierarchy()
    truncate_to_loinc_hierarchy()
	group_by_concept(; person_threshold=100)
	format(limit=2000)
end
  ╠═╡ =#

# ╔═╡ 946285d3-7d3c-43a3-a6a5-d76ace5581d4
# ╠═╡ skip_as_script = true
#=╠═╡
@query begin
    note()
	group_by_concept(; person_threshold=100)
end
  ╠═╡ =#

# ╔═╡ 6cab882d-8a11-4216-9c7e-65d2dd0521a6
# ╠═╡ skip_as_script = true
#=╠═╡

@query begin
    observation()
	group_by_concept(; person_threshold=100)
end
  ╠═╡ =#

# ╔═╡ 33c05c8b-d963-4dcf-a6c9-d98b39a0c71a
# ╠═╡ skip_as_script = true
#=╠═╡
@query begin
    procedure()
    to_procedure_hierarchies()
	group_by_concept(; person_threshold=100)
	format(limit=4000)
end

  ╠═╡ =#

# ╔═╡ a161630b-7eed-40c1-a1de-be5e5e22cfd7
# ╠═╡ skip_as_script = true
#=╠═╡
@query begin
    specimen()
	group_by_concept(; person_threshold=100)
end
  ╠═╡ =#

# ╔═╡ 5a2bd698-21bd-46f3-99f2-cefe0ca152ec
# ╠═╡ skip_as_script = true
#=╠═╡
@query begin
    visit()
	group_by_concept(; person_threshold=100)
end
  ╠═╡ =#

# ╔═╡ 244c0f09-603b-4dbb-ba54-4b3775691a81
begin icd10cm = @query icd10cm_chapter_concept_sets(); nothing; end

# ╔═╡ 12ca99d3-0170-47cb-bd2e-6c1cd14a7da7
@query begin
    condition()
	concept_sets_breakout(class => $icd10cm; with_icd9gem=true)
	to_3char_icdcm(with_icd9gem=true)
    group_by_concept(; person_threshold=100, include=[class])
    format(group_by=class, limit=3000)
end

# ╔═╡ fe876afa-b56f-47d1-85ef-83556798f8c4
TRDW.NotebookFooter()

# ╔═╡ Cell order:
# ╟─5506a86d-5464-403b-99f2-c569ecc8d357
# ╟─f99deebf-880e-43be-9287-71ae128a12ea
# ╟─92166f39-6a99-403d-aef5-1c9603ef5f78
# ╟─bfa24190-e9a8-44f4-b4b1-2f6473a3619b
# ╠═9f497e6c-d025-4956-b4e9-16eb3af11452
# ╟─8a5cc3e3-5f68-43da-ba11-cd66ae767eb6
# ╠═e9eaca17-b929-40c6-971a-6c88f84f80aa
# ╠═3d533264-d93b-4db3-a16d-9dca5c21d28a
# ╠═a6a28134-c214-49ee-9528-4dab55ae0af9
# ╠═b48528d7-d50b-4ea2-96ee-2fbe80f41cae
# ╠═7b6fec30-05ca-4be0-8057-2606dc2f75c0
# ╟─7993b812-41db-4b26-9599-9c468be8c579
# ╟─faca8760-27dc-4db7-aaeb-66b024e57fb3
# ╠═12ca99d3-0170-47cb-bd2e-6c1cd14a7da7
# ╟─5307be8f-68b4-42f7-a95f-b3a659dfe637
# ╠═e3188763-95d7-44ed-8132-8f817d1d91e8
# ╟─f4cc1362-2cbb-45af-9837-7a291d939927
# ╟─3c8a3ae5-5683-49a3-8de4-fe64eee77c92
# ╠═004633ce-46fa-40e9-b58b-5a636e9ce2ec
# ╟─db65452a-3dfd-46fc-9203-a746b57f574b
# ╟─cc40c8a0-e775-428c-a535-ebaaa3a0107b
# ╠═dcbe1232-0a75-4297-8635-4cb3e1564146
# ╟─9cfc0ba7-c2cc-4f07-9e32-cd76d5164467
# ╟─67a22c10-d1ae-4c1c-a908-3169f6056643
# ╠═946285d3-7d3c-43a3-a6a5-d76ace5581d4
# ╟─6b046afb-220a-43ef-9891-8c1fc87e3054
# ╠═6cab882d-8a11-4216-9c7e-65d2dd0521a6
# ╟─f4204dc6-5ff0-4993-bb20-3c676d0911dd
# ╠═33c05c8b-d963-4dcf-a6c9-d98b39a0c71a
# ╟─9a87439b-1f50-40fb-b451-f10e0140c8d9
# ╠═a161630b-7eed-40c1-a1de-be5e5e22cfd7
# ╟─8da34096-372b-421e-ab29-405aa399b8b7
# ╟─48f17065-25fb-4b85-89dc-15d4e6d5ae0f
# ╠═5a2bd698-21bd-46f3-99f2-cefe0ca152ec
# ╟─a63c96b8-f70e-47b3-a56d-52419b970975
# ╠═cdb19516-2411-11ee-1c6c-4f2a4b62200a
# ╠═8ec6f9c4-2d9c-4e0c-96d3-19012b4f8452
# ╠═a2ed12e7-7591-4a76-a2e3-7e91410c47a3
# ╠═244c0f09-603b-4dbb-ba54-4b3775691a81
# ╟─fe876afa-b56f-47d1-85ef-83556798f8c4
