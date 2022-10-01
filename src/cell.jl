mutable struct Cell
    current_tiles::Set{Tile}
    north_compatible::Set{Tile}
    east_compatible::Set{Tile}
    south_compatible::Set{Tile}
    west_compatible::Set{Tile}
    collapsed::Bool
end

base_cell(tile_set::Set{Tile}) = Cell(tile_set, tile_set, tile_set, tile_set, tile_set, false)