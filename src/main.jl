using Match
using Images
using FileIO

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



function wave_function_collapse(tile_set::Set{Tile}, grid_size::Tuple{UInt,UInt}; callback=x -> nothing)::Matrix{TileID}
    grid = Grid(map(_ -> base_cell(tile_set), ones(grid_size)), Dict(map(x -> (x, find_compatibility(x, tile_set)), collect(tile_set))))
    dump(find_compatibility(rand(tile_set), tile_set))
    grid_size_total = grid_size[1] * grid_size[2]
    while !all(map(x -> x.collapsed, grid.cells))
        collapse!(grid)
        num_of_collapsed_cells = length(filter(x -> x.collapsed, grid.cells))
        callback(num_of_collapsed_cells / grid_size_total)
    end
    image_grid = map(x -> (x.current_tiles |> collect |> first).tile_id, grid.cells)
    return image_grid
end

test(a) = collect(a.current_tiles)[1].tile_id

function wave_function_collapse(tile_set::Set{Tile}, grid_size::Tuple{Int,Int}; callback=x -> nothing)::Matrix{TileID}
    grid_size = convert(Tuple{UInt,UInt}, grid_size)
    wave_function_collapse(tile_set, grid_size, callback=callback)
end

function create_image_map(tile_set::Set{Tile}, basic_image_data)


    transformed_tiles = filter(x -> !basic(x.tile_id), collect(tile_set))
    image_data = Dict(map(x -> (new_basic_tile_id(x[1]), x[2]), collect(basic_image_data)))

    for tile in transformed_tiles

        tile_image = reduce((x, _) -> rotr90(x), 1:tile.tile_id.rotation, init=image_data[new_basic_tile_id(tile.tile_id.id)])
        if tile.tile_id.mirrored
            tile_image = tile_image[end:-1:1, :]
        end
        image_data[tile.tile_id] = tile_image

    end
    return image_data
end
