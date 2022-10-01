module WFC

using Pkg
Pkg.activate(".")
using Match
using Images

include("tile.jl")
include("cell.jl")
include("grid.jl")


function create_image(image_grid, image_map)

    image_size = size(image_map |> values |> collect |> rand)

    grid_size = size(image_grid)

    image = zeros(RGB, grid_size .* image_size)
    for j in 1:grid_size[2]
        for i in 1:grid_size[1]
            image[((i-1)*image_size[1]+1):i*image_size[1], ((j-1)*image_size[2]+1):j*image_size[2]] = image_map[image_grid[i, j]]
        end
    end
    return image
end



function wave_function_collapse(tile_set::Set{Tile}, grid_size::Tuple{UInt,UInt})::Matrix{UInt}
    grid = Grid(map(_ -> base_cell(tile_set), ones(grid_size)), Dict(map(x -> (x, find_compatibility(x, tile_set)), collect(tile_set))))

    while !all(map(x -> x.collapsed, grid.cells))
        collapse!(grid)
    end

    image_grid = map(x -> collect(x.current_tiles)[1].tile_ID, grid.cells)
    return image_grid
end

function wave_function_collapse(tile_set::Set{Tile}, grid_size::Tuple{Int,Int})::Matrix{UInt}
    grid_size = convert(Tuple{UInt,UInt}, grid_size)
    wave_function_collapse(tile_set, grid_size)
end

end