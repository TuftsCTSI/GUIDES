using PlutoSliderServer

function notebook_order(path)
    fm = PlutoSliderServer.Pluto.frontmatter(path)
    order_s = get(fm, "order", nothing)
    order = typemax(Int)
    if order_s isa String
        order = something(tryparse(Int, order_s), order)
    end
    order
end

const notebook_paths =
    if isempty(ARGS)
        [path
            for (order, path) in sort([(notebook_order(path), path)
            for path in PlutoSliderServer.find_notebook_files_recursive(".")])]
    else
        ARGS
    end

PlutoSliderServer.export_directory(".", notebook_paths = notebook_paths)
