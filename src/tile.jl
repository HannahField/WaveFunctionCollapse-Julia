using Match
struct TileID
    id::UInt
    rotation::UInt
    mirrored::Bool
end

basic(tile_id::TileID) = tile_id.rotation == 0 && !tile_id.mirrored

new_basic_tile_id(id::Integer) = TileID(id, 0, false)

struct Tile
    north_socket_ID::UInt
    east_socket_ID::UInt
    south_socket_ID::UInt
    west_socket_ID::UInt
    tile_ID::TileID
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

function create_tile_set(tile::Tile, rotation::Int, reflection::Bool)
    tile_set = Set([tile])

    rotated_tiles = @match rotation begin
        1 => []
        2 => [rotate_tile(rotate_tile(tile))]
        4 => [
            rotate_tile(tile),
            rotate_tile(rotate_tile(tile)),
            rotate_tile(rotate_tile(rotate_tile(tile)))
        ]
    end
    tile_set = union(tile_set, Set(rotated_tiles))
    if reflection
        reflected_tile = Tile(new_tile.south_socket_ID, new_tile.east_socket_ID, new_tile.north_socket_ID, new_tile.west_socket_ID, (new_tile.tile_ID.id, 0, true))
        tile_set = union(tile_set, Set(reflected_tile))
        rotated_reflected_tiles = @match rotation begin
            1 => []
            2 => [rotate_tile(rotate_tile(reflected_tile))]
            4 => [
                rotate_tile(reflected_tile),
                rotate_tile(rotate_tile(reflected_tile)),
                rotate_tile(rotate_tile(rotate_tile(reflected_tile)))
            ]
        end
        tile_set = union(tile_set, Set(rotated_reflected_tiles))
    end
    return tile_set
end

rotate_tile(tile::Tile)::Tile = Tile(
    tile.west_socket_ID,
    tile.north_socket_ID,
    tile.east_socket_ID,
    tile.south_socket_ID,
    TileID(
        tile.tile_ID.id,
        tile.tile_ID.rotation + 1,
        tile.tile_ID.mirrored
    )
)
