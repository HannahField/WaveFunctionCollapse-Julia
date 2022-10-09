module WFC

using Pkg
Pkg.activate(".")
using Match
using Images

include("tile.jl")
include("cell.jl")
include("grid.jl")


function create_image(image_grid, image_map)
    image_map = Dict(map(x -> (TileId(x[1], nothing_strategy()), x[2]), collect(image_map)))

    image_size = size(image_map |> values |> collect |> rand)

    grid_size = size(image_grid)

    image = zeros(RGB, grid_size .* image_size)
    for j in 1:grid_size[2]
        for i in 1:grid_size[1]
            id = image_grid[i, j]
            if !haskey(image_map, id)
                image_map[id] = image_transformation(
                    id.transformation,
                    image_map[TileId(id.id, nothing_strategy())]
                )
            end
            image[((i-1)*image_size[1]+1):i*image_size[1], ((j-1)*image_size[2]+1):j*image_size[2]] = image_map[id]
        end
    end
    return image
end



function wave_function_collapse(tile_set::Set{Tile}, grid_size::Tuple{UInt,UInt})::Matrix{TileId}
    grid = Grid(map(_ -> base_cell(tile_set), ones(grid_size)), Dict(map(x -> (x, find_compatibility(x, tile_set)), collect(tile_set))))

    while !all(map(x -> x.collapsed, grid.cells))
        collapse!(grid)
    end

    image_grid = map(x -> collect(x.current_tiles)[1].tile_id, grid.cells)
    return image_grid
end

function wave_function_collapse(tile_set::Set{Tile}, grid_size::Tuple{Int,Int})::Matrix{TileId}
    grid_size = convert(Tuple{UInt,UInt}, grid_size)
    wave_function_collapse(tile_set, grid_size)
end

end
