pluto:
	julia --project=. -e 'using Pkg; Pkg.instantiate(); using Pluto; Pluto.run()'

julia:
	julia --project=. -e "using Pkg; Pkg.instantiate(); using Revise; using TRDW;" -i

pkg_update:
	julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.update();'

latest_trdw:
	julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.add(url="https://github.com/TuftsCTSI/TRDW.jl.git")'

develop_trdw:
	julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.develop(path="${HOME}/TRDW.jl")'

discover.html:
	julia --project=. -e 'using PlutoSliderServer; PlutoSliderServer.export_notebook("discover.jl"; Export_offer_binder = false)'

export.html:
	julia --project=. -e 'using PlutoSliderServer; PlutoSliderServer.export_notebook("export.jl"; Export_offer_binder = false)'

clean:
	rm -f *.html *.7z *.zip exported.txt *.csv
