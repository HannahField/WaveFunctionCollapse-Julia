struct Grid 
    cells::Matrix{Cell}
    tile_compatibility::Dict{Tile,TileCompatibility}
end

function propagate!(grid::Grid, index::Tuple{UInt,UInt})::Nothing
    neighbors_indeces = find_neighbors_index(index, convert(Tuple{UInt,UInt}, size(grid.cells)))
    non_collapsed_neighbors = filter(x -> !grid.cells[x...].collapsed, neighbors_indeces)
    current_cell = grid.cells[index...]
    for i in non_collapsed_neighbors
        dir = convert(Tuple{Int,Int}, index) .- convert(Tuple{Int,Int}, i)
        direction_compatibility = @match dir begin
            (1, 0) => current_cell.north_compatible
            (0, -1) => current_cell.east_compatible
            (-1, 0) => current_cell.south_compatible
            (0, 1) => current_cell.west_compatible
        end
        #println(directionCompatibility)
        new_current_tiles = intersect(grid.cells[i...].current_tiles, direction_compatibility)
        if !(new_current_tiles == grid.cells[i...].current_tiles)
            grid.cells[i...].current_tiles = new_current_tiles
            union_compatibilities!(grid, i)
            propagate!(grid, i)
        end
    end
    return nothing
end


function collapse!(grid::Grid)::Nothing
    index = find_least_entropy(grid)

    least_entropy_cell = grid.cells[index...]

    possible_outcomes = least_entropy_cell.current_tiles
    outcome = rand(possible_outcomes)

    grid.cells[index...].current_tiles = Set([outcome])
    grid.cells[index...].collapsed = true
    union_compatibilities!(grid, index)

    propagate!(grid, index)
    return nothing
end

function union_compatibilities!(grid::Grid, index::Tuple{UInt,UInt})::Nothing
    superposition_of_tile_compatibilities = map(x -> grid.tile_compatibility[x], collect(grid.cells[index...].current_tiles))
    grid.cells[index...].north_compatible = Set(union(map(x -> x.north_neighbors, superposition_of_tile_compatibilities)...))
    grid.cells[index...].east_compatible = Set(union(map(x -> x.east_neighbors, superposition_of_tile_compatibilities)...))
    grid.cells[index...].south_compatible = Set(union(map(x -> x.south_neighbors, superposition_of_tile_compatibilities)...))
    grid.cells[index...].west_compatible = Set(union(map(x -> x.west_neighbors, superposition_of_tile_compatibilities)...))
    return nothing
end

function find_least_entropy(grid::Grid)::Tuple{UInt,UInt}
    _, index = findmin(map(x -> length(x.current_tiles) + (!x.collapsed ? 0 : 10), grid.cells))
    index = Tuple(index)
    return index
end


function find_neighbors_index(index::Tuple{UInt,UInt}, size::Tuple{UInt,UInt})::Vector{Tuple{UInt,UInt}}
    indeces = [
        (index[1] - 1, index[2])
        (index[1], index[2] + 1)
        (index[1] + 1, index[2])
        (index[1], index[2] - 1)
    ]
    filter!(x -> x[1] in 1:size[1] && x[2] in 1:size[2], indeces)
    return indeces
end
