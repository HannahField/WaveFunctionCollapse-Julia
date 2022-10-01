struct Tile
    north_socket_ID::UInt8
    east_socket_ID::UInt8
    south_socket_ID::UInt8
    west_socket_ID::UInt8
    tile_ID::UInt8
end

struct TileCompatibility
    tile::Tile
    north_neighbors::Set{Tile}
    east_neighbors::Set{Tile}
    south_neighbors::Set{Tile}
    west_neighbors::Set{Tile}
end

function find_compatibility(tile::Tile, tiles::Set{Tile})
    north_compatibility = Set(filter(x -> x.south_socket_ID == tile.north_socket_ID, tiles))
    east_compatibility = Set(filter(x -> x.west_socket_ID == tile.east_socket_ID, tiles))
    south_compatibility = Set(filter(x -> x.north_socket_ID == tile.south_socket_ID, tiles))
    west_compatibility = Set(filter(x -> x.east_socket_ID == tile.west_socket_ID, tiles))
    return TileCompatibility(tile, north_compatibility, east_compatibility, south_compatibility, west_compatibility)
end