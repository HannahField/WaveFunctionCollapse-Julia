using Match
struct TileID
    id::UInt
    rotation::UInt
    mirrored::Bool
end
struct Sockets
    north_socket_id::UInt
    east_socket_id::UInt
    south_socket_id::UInt
    west_socket_id::UInt
end

basic(tile_id::TileID) = tile_id.rotation == 0 && !tile_id.mirrored

new_basic_tile_id(id::Integer) = TileID(id, 0, false)

struct Tile
    sockets::Sockets
    tile_id::TileID
end

struct TileCompatibility
    tile::Tile
    north_neighbors::Set{Tile}
    east_neighbors::Set{Tile}
    south_neighbors::Set{Tile}
    west_neighbors::Set{Tile}
end

function find_compatibility(tile::Tile, tiles::Set{Tile})
    north_compatibility = Set(filter(x -> x.sockets.south_socket_id == tile.sockets.north_socket_id, tiles))
    east_compatibility = Set(filter(x -> x.sockets.west_socket_id == tile.sockets.east_socket_id, tiles))
    south_compatibility = Set(filter(x -> x.sockets.north_socket_id == tile.sockets.south_socket_id, tiles))
    west_compatibility = Set(filter(x -> x.sockets.east_socket_id == tile.sockets.west_socket_id, tiles))
    return TileCompatibility(tile, north_compatibility, east_compatibility, south_compatibility, west_compatibility)
end

function create_tile_set(sockets::Sockets, id::Int, rotation::Int, reflection::Bool)
    basic_tile = Tile(sockets, new_basic_tile_id(id))
    tile_set = Set([basic_tile])

    rotated_tiles = @match rotation begin
        1 => []
        2 => [rotate_tile(basic_tile)]
        4 => [
            rotate_tile(basic_tile),
            rotate_tile(rotate_tile(basic_tile)),
            rotate_tile(rotate_tile(rotate_tile(basic_tile)))
        ]
    end
    tile_set = union(tile_set, Set(rotated_tiles))
    if reflection
        reflected_tile = Tile(Sockets(basic_tile.sockets.south_socket_id,
        basic_tile.sockets.east_socket_id,
        basic_tile.sockets.north_socket_id,
        basic_tile.sockets.west_socket_id),
            TileID(basic_tile.tile_id.id, 0, true))
        tile_set = union(tile_set, Set([reflected_tile]))
        rotated_reflected_tiles = @match rotation begin
            1 => []
            2 => [rotate_tile(reflected_tile)]
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
    Sockets(
        tile.sockets.west_socket_id,
        tile.sockets.north_socket_id,
        tile.sockets.east_socket_id,
        tile.sockets.south_socket_id
    ),
    TileID(
        tile.tile_id.id,
        tile.tile_id.rotation + 1,
        tile.tile_id.mirrored
    )
)
