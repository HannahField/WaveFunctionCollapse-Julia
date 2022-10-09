include("../../src/main.jl")
using Pkg
using Images
using FileIO
tiles = [
    WFC.Tile(0, 0, 0, 0, WFC.new_basic_tile_id(1)),
    WFC.Tile(1, 0, 1, 1, WFC.new_basic_tile_id(2)),
    #WFC.Tile(1, 1, 0, 1, (3,0,false)),
    #WFC.Tile(1, 1, 1, 0, (4,0,false)),
    #WFC.Tile(0, 1, 1, 1, (5,0,false)), 
    WFC.Tile(1, 0, 0, 1, WFC.new_basic_tile_id(6)),
    #WFC.Tile(1, 1, 0, 0, (7,0,false)),
    #WFC.Tile(0, 1, 1, 0, (8,0,false)),
    #WFC.Tile(0, 0, 1, 1, (9,0,false)),
    WFC.Tile(1, 0, 1, 0, WFC.new_basic_tile_id(10)),
    #WFC.Tile(0, 1, 0, 1, (11,0,false)),
    WFC.Tile(1, 1, 1, 1, WFC.new_basic_tile_id(12))
]

tile_set = Set([
    WFC.create_tile_set(tiles[1], 1, false)...,
    WFC.create_tile_set(tiles[2], 4, false)...,
    WFC.create_tile_set(tiles[3], 4, false)...,
    WFC.create_tile_set(tiles[4], 2, false)...,
    WFC.create_tile_set(tiles[5], 1, false)...
])
println(map(x -> x.tile_id, collect(tile_set)))
image_grid = WFC.wave_function_collapse(tile_set, (12, 12))
#println(image)




#image_map = Dict(map(x -> (x.tile_id, FileIO.load(string(@__DIR__,"/tiles/Tile", x.tile_id[1], ".png"))), tiles))
basic_image_data = Dict(map(x -> (x.tile_id.id, FileIO.load(string(@__DIR__, "/tiles/Tile", x.tile_id.id, ".png"))), tiles))


image_map = WFC.create_image_map(tile_set, basic_image_data)


image_data = WFC.create_image(image_grid, image_map)

FileIO.save(string(@__DIR__, "/test.png"), image_data)
