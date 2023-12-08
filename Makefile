pluto:
	julia --project=. -e 'using Pkg; Pkg.instantiate(); using Pluto; Pluto.run()'

julia:
	julia --project=. --load=load.jl

pkg_update:
	julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.update();'

latest_trdw:
	julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.add(url="https://github.com/TuftsCTSI/TRDW.jl.git")'

develop_trdw:
	julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.develop(path="${HOME}/TRDW.jl")'

notebook:
	julia --project=. -e 'using PlutoSliderServer; PlutoSliderServer.export_notebook("explore.jl"; Export_offer_binder = false)'
