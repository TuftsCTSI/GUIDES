ifeq ($(CI),true)
EXPORT_DIR ?= /run/notebooks/html/$(notdir $(CURDIR))
CACHE_DIR ?= /run/notebooks/cache/$(notdir $(CURDIR))
endif

#export RENV_WATCHDOG_ENABLED = FALSE
#export RENV_PATHS_LIBRARY_ROOT = $(HOME)/.cache/R/renv/library
#ifeq ($(CI),true)
#export RENV_PATHS_LIBRARY_ROOT_ASIS = TRUE
#endif
#export LD_LIBRARY_PATH = /usr/lib/jvm/default-java/lib/server
export JULIA_COPY_STACKS = 1

help: #: show this help
	@echo "Available targets:"
	@sed -n -e 's/^\([^:@]*\):.*#: \(.*\)/  make \1  |\2/p' Makefile | column -t -s '|'
.PHONY: help

pluto: #: start a Pluto notebook server
	julia --project -e 'using Pluto; Pluto.run()'
.PHONY: pluto

setup: #: setup Julia and R environments
	[ -z "$(CACHE_DIR)" ] || [ ! -e "$(CACHE_DIR)/julia.tar.gz" ] || tar -xaf "$(CACHE_DIR)/julia.tar.gz" -C $(HOME)/.julia
	#[ -z "$(CACHE_DIR)" ] || [ ! -e "$(CACHE_DIR)/R.tar.gz" ] || tar -xaf "$(CACHE_DIR)/R.tar.gz" -C $(HOME)/.cache/R
	julia --project -e 'using Pkg; Pkg.instantiate()'
	#[ ! -e renv.lock ] || Rscript -e 'renv::init(); renv::restore()'
	[ -z "$(CACHE_DIR)" ] || [ -e "$(CACHE_DIR)" ] || mkdir "$(CACHE_DIR)"
	[ -z "$(CACHE_DIR)" ] || tar -czf "$(CACHE_DIR)/julia.tar.gz" -C $(HOME)/.julia .
	#[ -z "$(CACHE_DIR)" ] || [ ! -e renv.lock ] || tar -czf "$(CACHE_DIR)/R.tar.gz" -C $(HOME)/.cache/R .
.PHONY: setup

build: setup #: build notebooks
	[ -z "$(CACHE_DIR)" ] || [ ! -e "$(CACHE_DIR)/pluto.tar.gz" ] || tar -xaf "$(CACHE_DIR)/pluto.tar.gz"
	julia --project ./_build.jl
	[ -z "$(CACHE_DIR)" ] || tar -czf "$(CACHE_DIR)/pluto.tar.gz" .pluto_state_cache
.PHONY: build

export: build #: build and export notebooks
	[ -z "$(EXPORT_DIR)" ] || [ -e "$(EXPORT_DIR)" ] || mkdir "$(EXPORT_DIR)"
	[ -z "$(EXPORT_DIR)" ] || cp -r * "$(EXPORT_DIR)"
.PHONY: export

trdw_shell: #: start Julia directly without Pluto
	julia --project -e "using FunSQL, Revise; using TRDW;" -i
.PHONY: trdw_shell

pkg_update: #: update all Julia packages
	julia --project -e 'using Pkg; Pkg.instantiate(); Pkg.update();'
.PHONY: pkg_update

latest_trdw: #: use the latest main branch copy of TRDW.jl
	julia --project -e 'using Pkg; Pkg.add(url="https://github.com/TuftsCTSI/TRDW.jl"); Pkg.instantiate()'
.PHONY: latest_trdw

develop_trdw: #: use local development copy of TRDW.jl
	julia --project -e 'using Pkg; Pkg.develop(url="git@github.com:TuftsCTSI/TRDW.jl.git"); Pkg.instantiate()'
	@echo "You can edit TRDW.jl at ~/.julia/dev/TRDW/"
.PHONY: develop_trdw

purge-julia-cache: #: delete Julia package cache
	[ -z "$(CACHE_DIR)" ] || rm -f "$(CACHE_DIR)/julia.tar.gz"
.PHONY: purge-julia-cache

purge-r-cache: #: delete R package cache
	[ -z "$(CACHE_DIR)" ] || rm -f "$(CACHE_DIR)/R.tar.gz"
.PHONY: purge-r-cache

purge-pluto-cache: #: delete Pluto notebook cache
	[ -z "$(CACHE_DIR)" ] || rm -f "$(CACHE_DIR)/pluto.tar.gz"
.PHONY: purge-pluto-cache

purge-cache: purge-julia-cache purge-r-cache purge-pluto-cache #: clear all package and notebook caches
.PHONY: purge-cache

%.html: %.jl # render single notebook
	julia --project -e 'using PlutoSliderServer; PlutoSliderServer.export_notebook("$<")'

clean: #: delete generated files
	rm -f *.html *.csv *.xlsx *.zip pluto_export.json .Rprofile
	rm -rf renv .pluto_state_cache pluto_export.json
.PHONY: clean
