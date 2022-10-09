include("transformation_strategy.jl")

struct TileId
    id::UInt8
    transformation::TransformationStrategy
end

struct Tile
    north_socket_id::UInt8
    east_socket_id::UInt8
    south_socket_id::UInt8
    west_socket_id::UInt8
    tile_id::TileId
end

function new_tiles(north_socket_id::Int, east_socket_id::Int ,south_socket_id::Int, west_socket_id::Int, tile_id::Int, transformations::Vector{TransformationStrategy})::Vector{Tile}
    ids = map(x -> TileId(tile_id, x), transformations)
    map(x -> tile_transformation(x.transformation, Tile(north_socket_id, east_socket_id, south_socket_id, west_socket_id, x)), ids)
end

function tile_transformation(transformation::TransformationStrategy, tile::Tile)
    tile_transformation(transformation.rotation, tile_transformation(transformation.mirror, tile))
  end 
  
function tile_transformation(transformation::MirrorStrategy, tile::Tile)
return if transformation.mirror
    Tile(
    tile.south_socket_id,
    tile.east_socket_id,
    tile.north_socket_id,
    tile.west_socket_id,
    tile.tile_id
    )
else
    tile
end
end
  
rotate_tile_once(tile::Tile) = Tile(tile.west_socket_id, tile.north_socket_id, tile.east_socket_id, tile.west_socket_id, tile.tile_id)

function tile_transformation(transformation::RotationStrategy, input_tile::Tile)
    tile = input_tile
    for _ in 0:transformation.rotations
        tile = rotate_tile_once(tile)
    end
    tile
end


struct TileCompatibility
    tile::Tile
    north_neighbors::Set{Tile}
    east_neighbors::Set{Tile}
    south_neighbors::Set{Tile}
    west_neighbors::Set{Tile}
end

function find_compatibility(tile::Tile, tiles::Set{Tile})
    north_compatibility = Set(filter(x -> x.south_socket_id == tile.north_socket_id, tiles))
    east_compatibility = Set(filter(x -> x.west_socket_id == tile.east_socket_id, tiles))
    south_compatibility = Set(filter(x -> x.north_socket_id == tile.south_socket_id, tiles))
    west_compatibility = Set(filter(x -> x.east_socket_id == tile.west_socket_id, tiles))
    return TileCompatibility(tile, north_compatibility, east_compatibility, south_compatibility, west_compatibility)
end

