include("../../src/main.jl")
using Pkg
using Images
using FileIO
tiles = [
    WFC.Tile(0, 0, 0, 0, (1,0,false)),
    WFC.Tile(1, 0, 1, 1, (2,0,false)),
    #WFC.Tile(1, 1, 0, 1, (3,0,false)),
    #WFC.Tile(1, 1, 1, 0, (4,0,false)),
    #WFC.Tile(0, 1, 1, 1, (5,0,false)), 
    WFC.Tile(1, 0, 0, 1, (6,0,false)),
    #WFC.Tile(1, 1, 0, 0, (7,0,false)),
    #WFC.Tile(0, 1, 1, 0, (8,0,false)),
    #WFC.Tile(0, 0, 1, 1, (9,0,false)),
    WFC.Tile(1, 0, 1, 0, (10,0,false)),
    #WFC.Tile(0, 1, 0, 1, (11,0,false)),
    WFC.Tile(1, 1, 1, 1, (12,0,false))
]

tile_set = Set([
    WFC.create_tile_set(tiles[1],1,false)...,
    WFC.create_tile_set(tiles[2],4,false)...,
    WFC.create_tile_set(tiles[3],4,false)...,
    WFC.create_tile_set(tiles[4],2,false)...,
    WFC.create_tile_set(tiles[5],1,false)...
])
println(map(x -> x.tile_ID,collect(tile_set)))
image_grid = WFC.wave_function_collapse(tile_set,(12,12))
#println(image)



#image_map = Dict(map(x -> (x.tile_ID, FileIO.load(string(@__DIR__,"/tiles/Tile", x.tile_ID[1], ".png"))), tiles))
basic_image_data = Dict(map(x -> (x.tile_ID[1], FileIO.load(string(@__DIR__,"/tiles/Tile", x.tile_ID[1], ".png"))), tiles))


image_map = WFC.create_image_map(tile_set,basic_image_data)


image_data = WFC.create_image(image_grid,image_map)

FileIO.save(string(@__DIR__,"/test.png"),image_data)