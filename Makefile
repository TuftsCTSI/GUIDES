pluto:
	JULIA_COPY_STACKS=1 julia -e 'using Pluto; Pluto.run()'

julia:
	JULIA_COPY_STACKS=1 julia --project=. -e "using Pkg; Pkg.instantiate(); using FunSQL, Revise; using TRDW;" -i

environment:
	julia  -e 'using Pkg; Pkg.add(url="https://github.com/MechanicalRabbit/Pluto.jl.git#funsql")'
	julia  -e 'using Pkg; Pkg.add("PlutoSliderServer")'

pkg_update:
	-julia --project=. -e 'using Pkg; Pkg.rm("Pluto")' > /dev/null 2> /dev/null # remove local Pluto
	-julia --project=. -e 'using Pkg; Pkg.rm("PlutoSliderServer")' > /dev/null 2> /dev/null
	-julia --project=. -e 'using Pkg; Pkg.add("JavaCall")' # needed for encrypted excel and Circe
	julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.update();'

latest_trdw:
	julia --project=. -e 'using Pkg; Pkg.add(url="https://github.com/TuftsCTSI/TRDW.jl.git"); Pkg.instantiate()'

revised_trdw:
	julia --project=. -e 'using Pkg; Pkg.add(url="https://github.com/TuftsCTSI/TRDW.jl.git", rev="connect-macro"); Pkg.instantiate()'

develop_trdw:
	julia --project=. -e 'using Pkg; Pkg.develop(path="${HOME}/TRDW.jl"); Pkg.instantiate()'

%.html: %.jl
	JULIA_COPY_STACKS=1 julia --project=. -e 'using PlutoSliderServer; PlutoSliderServer.export_notebook("$<"; Export_offer_binder = false)'

clean:
	rm -f *.html *.7z *.zip exported.txt *.csv *.xlsx
